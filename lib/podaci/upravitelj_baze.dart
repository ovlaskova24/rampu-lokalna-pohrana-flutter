import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

// Singleton – u cijeloj aplikaciji postoji samo jedna instanca ove klase.
class UpraviteljBaze {
  // Privatni konstruktor – izvana se ne može napraviti novi objekt
  UpraviteljBaze._();

  // Jedina instanca, dostupna kao UpraviteljBaze.instanca
  static final UpraviteljBaze instanca = UpraviteljBaze._();

  static const String _nazivBaze = 'memento.db';

  // Verzija 1: kategorija + zadatak
  // Verzija 2: dodan podzadatak (slabi entitet)
  static const int _verzija = 2;

  // Future – kao Promise u JavaScriptu (baza nije odmah gotova).
  // ? znači da varijabla smije biti null (na početku baza još nije otvorena).
  Future<Database>? _baza;

  // Getter: ??= znači "pozovi _otvori() samo ako baza još nije otvorena".
  Future<Database> get baza => _baza ??= _otvori();

  Future<Database> _otvori() {
    return openDatabase(
      _nazivBaze,
      version: _verzija,

      // Poziva se pri SVAKOM otvaranju, uključuje provjeru stranih ključeva
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      // Baza NE postoji (nova instalacija), izvrši sve skripte redom
      onCreate: (db, verzija) async {
        await _izvrsiSkriptu(db, 'assets/sql/kreirajBazu.sql');
        await _izvrsiSkriptu(db, 'assets/sql/azurirajBazu_v2.sql');
      },

      // Baza POSTOJI, ali je starija verzija, izvrši samo ono što nedostaje
      onUpgrade: (db, staraVerzija, novaVerzija) async {
        print('Nadogradnja baze s verzije $staraVerzija na $novaVerzija');

        if (staraVerzija < 2) {
          await _izvrsiSkriptu(db, 'assets/sql/azurirajBazu_v2.sql');
        }
      },
    );
  }

  // Čita .sql datoteku iz assets i izvršava naredbu po naredbu
  Future<void> _izvrsiSkriptu(Database db, String putanja) async {
    // 1) Učitaj cijelu .sql datoteku kao jedan tekst
    String sadrzaj = await rootBundle.loadString(putanja);

    // 2) Razreži tekst na dijelove – svaka SQL naredba završava s ;
    List<String> dijelovi = sadrzaj.split(';');

    // 3) Izvrši svaku naredbu posebno
    for (String dio in dijelovi) {
      String naredba = dio.trim(); // makni razmake i prazne retke

      if (naredba.isEmpty) {
        continue; // preskoči prazan dio (npr. onaj iza zadnjeg ;)
      }

      await db.execute(naredba);
    }
  }
}