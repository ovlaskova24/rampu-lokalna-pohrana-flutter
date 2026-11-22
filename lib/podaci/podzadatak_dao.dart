import '../interface/podzadatak.dart';
import 'upravitelj_baze.dart';

class PodzadatakDAO {
  // NATURAL JOIN: podzadaci jednog zadatka zajedno s naslovom zadatka
  Future<List<Podzadatak>> dohvatiZaZadatak(int zadatakId) async {
    var baza = await UpraviteljBaze.instanca.baza;

    var redci = await baza.rawQuery(
      'SELECT * FROM zadatak NATURAL JOIN podzadatak '
          'WHERE zadatak_id = ? ORDER BY redni_broj',
      [zadatakId],
    );

    List<Podzadatak> podzadaci = [];

    for (var redak in redci) {
      var podzadatak = Podzadatak(
        zadatakId: redak['zadatak_id'] as int,
        redniBroj: redak['redni_broj'] as int,
        opis: redak['opis'] as String,
        obavljen: redak['obavljen'] == 1,
        naslovZadatka: redak['naslov'] as String,
      );
      podzadaci.add(podzadatak);
    }

    return podzadaci;
  }
}