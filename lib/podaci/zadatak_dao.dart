import '../interface/zadatak.dart';
import 'upravitelj_baze.dart';

class ZadatakDAO {
  // SELECT – dohvati sve zadatke
  Future<List<Zadatak>> dohvatiSve() async {
    var baza = await UpraviteljBaze.instanca.baza;

    var redci = await baza.rawQuery('SELECT * FROM zadatak');

    List<Zadatak> zadaci = [];

    for (var redak in redci) {
      var zadatak = Zadatak(
        id: redak['zadatak_id'] as int,
        naslov: redak['naslov'] as String,
        zavrsen: redak['zavrsen'] == 1,
        kategorijaId: redak['kategorija_id'] as int,
      );
      zadaci.add(zadatak);
    }

    return zadaci;
  }

  // INSERT – dodaj novi zadatak
  Future<void> dodaj(Zadatak zadatak) async {
    var baza = await UpraviteljBaze.instanca.baza;

    await baza.rawInsert(
      'INSERT INTO zadatak (naslov, kategorija_id) VALUES (?, ?)',
      [zadatak.naslov, zadatak.kategorijaId],
    );
  }

  // UPDATE – označi zadatak kao završen ili nezavršen
  Future<void> postaviZavrsen(int id, bool zavrsen) async {
    var baza = await UpraviteljBaze.instanca.baza;

    var vrijednost = 0;
    if (zavrsen) {
      vrijednost = 1;
    }

    await baza.rawUpdate(
      'UPDATE zadatak SET zavrsen = ? WHERE zadatak_id = ?',
      [vrijednost, id],
    );
  }

  // DELETE – obriši zadatak
  Future<void> obrisi(int id) async {
    var baza = await UpraviteljBaze.instanca.baza;

    await baza.rawDelete(
      'DELETE FROM zadatak WHERE zadatak_id = ?',
      [id],
    );
  }
  // INNER JOIN – zadaci zajedno s nazivom i bojom kategorije
  Future<List<Zadatak>> dohvatiSKategorijom() async {
    var baza = await UpraviteljBaze.instanca.baza;

    var redci = await baza.rawQuery(
      'SELECT * FROM zadatak '
          'INNER JOIN kategorija ON zadatak.kategorija_id = kategorija.kategorija_id',
    );

    List<Zadatak> zadaci = [];

    for (var redak in redci) {
      var zadatak = Zadatak(
        id: redak['zadatak_id'] as int,
        naslov: redak['naslov'] as String,
        zavrsen: redak['zavrsen'] == 1,
        kategorijaId: redak['kategorija_id'] as int,
        nazivKategorije: redak['naziv_kategorije'] as String,
        boja: redak['boja'] as String,
      );
      zadaci.add(zadatak);
    }

    return zadaci;
  }


  // NATURAL JOIN: isti rezultat, ali baza sama pronalazi zajednički stupac
  Future<List<Zadatak>> dohvatiPrirodnimSpojem() async {
    var baza = await UpraviteljBaze.instanca.baza;

    var redci = await baza.rawQuery(
      'SELECT * FROM zadatak NATURAL JOIN kategorija',
    );

    List<Zadatak> zadaci = [];

    for (var redak in redci) {
      var zadatak = Zadatak(
        id: redak['zadatak_id'] as int,
        naslov: redak['naslov'] as String,
        zavrsen: redak['zavrsen'] == 1,
        kategorijaId: redak['kategorija_id'] as int,
        nazivKategorije: redak['naziv_kategorije'] as String,
        boja: redak['boja'] as String,
      );
      zadaci.add(zadatak);
    }

    return zadaci;
  }


}