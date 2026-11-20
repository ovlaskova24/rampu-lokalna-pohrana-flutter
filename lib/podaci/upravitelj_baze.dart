import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

// Singleton – u cijeloj aplikaciji postoji samo jedna instanca ove klase.
class UpraviteljBaze {

  // Privatni konstruktor,  izvana se ne može napraviti novi objekt
  UpraviteljBaze._();

  // Jedina instanca, dostupna kao UpraviteljBaze.instanca
  static final UpraviteljBaze instanca = UpraviteljBaze._();

  static const String _nazivBaze = 'memento.db';
  static const int _verzija = 1;

  // Future – kao Promise u JavaScriptu (baza nije odmah gotova).
  // ? znači da varijabla smije biti null (na početku baza još nije otvorena).
  Future<Database>? _baza;

  // Getter: ??= znači "pozovi _otvori() samo ako baza još nije otvorena".
  Future<Database> get baza => _baza ??= _otvori();

  Future<Database> _otvori() {
    return openDatabase(
      _nazivBaze,
      version: _verzija,

      // Poziva se pri svakom otvaranju, uključuje provjeru stranih ključeva
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      // Poziva se samo kad baza NE postoji (pri prvom pokretanju aplikacije)
      onCreate: (db, verzija) async {
        await _izvrsiSkriptu(db, 'assets/sql/kreirajBazu.sql');
      },
    );
  }

  // Čita .sql datoteku iz assets i izvršava naredbu po naredbu
  Future<void> _izvrsiSkriptu(Database db, String putanja) async {
    // 1Učitaj cijelu .sql datoteku kao jedan tekst
    String sadrzaj = await rootBundle.loadString(putanja);

    // 2 Razreži tekst na dijelove. Svaka SQL naredba završava s ;
    List<String> dijelovi = sadrzaj.split(';');

    // 3 Izvrši svaku naredbu posebno
    for (String dio in dijelovi) {
      String naredba = dio.trim(); // makni razmake i prazne retke

      if (naredba.isEmpty) {
        continue; // preskoči prazan dio (npr. onaj iza zadnjeg ;)
      }

      await db.execute(naredba);
    }
  }
}