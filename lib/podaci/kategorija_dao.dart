import '../interface/kategorija.dart';
import 'upravitelj_baze.dart';

class KategorijaDAO {
  // Dohvati sve kategorije iz baze
  Future<List<Kategorija>> dohvatiSve() async {
    var baza = await UpraviteljBaze.instanca.baza;

    var redci = await baza.rawQuery('SELECT * FROM kategorija');

    List<Kategorija> kategorije = [];

    for (var redak in redci) {
      var kategorija = Kategorija(
        id: redak['kategorija_id'] as int,
        naziv: redak['naziv_kategorije'] as String,
        boja: redak['boja'] as String,
      );
      kategorije.add(kategorija);
    }

    return kategorije;
  }
}