import 'package:material_ui/material_ui.dart';

import '../interface/kategorija.dart';
import '../interface/zadatak.dart';
import '../podaci/kategorija_dao.dart';
import '../podaci/zadatak_dao.dart';

// ================= EKRAN S LISTOM ZADATAKA =================

class BazaEkran extends StatefulWidget {
  const BazaEkran({super.key});

  @override
  State<BazaEkran> createState() => _BazaEkranState();
}

class _BazaEkranState extends State<BazaEkran> {
  var zadatakDAO = ZadatakDAO();
  var kategorijaDAO = KategorijaDAO();

  List<Zadatak> zadaci = [];

  // Poziva se jednom, kad se ekran prvi put prikaže
  @override
  void initState() {
    super.initState();
    ucitajZadatke();
  }

  // >>> DAO: SELECT s INNER JOIN-om
  Future<void> ucitajZadatke() async {
    var rezultat = await zadatakDAO.dohvatiSKategorijom();
    setState(() {
      zadaci = rezultat;
    });
  }

  // >>> DAO: UPDATE
  Future<void> promijeniZavrsen(Zadatak zadatak) async {
    await zadatakDAO.postaviZavrsen(zadatak.id!, !zadatak.zavrsen);
    await ucitajZadatke();
  }

  // >>> DAO: DELETE
  Future<void> obrisiZadatak(Zadatak zadatak) async {
    await zadatakDAO.obrisi(zadatak.id!);
    await ucitajZadatke();
  }

  // Otvara prozor za novi zadatak (INSERT se radi u prozoru)
  Future<void> otvoriDijalog() async {
    var kategorije = await kategorijaDAO.dohvatiSve();
    if (!mounted) return;

    var dodan = await showDialog<bool>(
      context: context,
      builder: (context) => NoviZadatakDijalog(kategorije: kategorije),
    );

    if (dodan == true) {
      await ucitajZadatke();
    }
  }

  // Pretvara '#000080' u boju
  Color pretvoriBoju(String? hex) {
    if (hex == null) {
      return Colors.grey;
    }
    var broj = int.parse(hex.substring(1), radix: 16);
    return Color(0xFF000000 + broj);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zadaci')),
      body: ListView.builder(
        itemCount: zadaci.length,
        itemBuilder: (context, i) {
          var zadatak = zadaci[i];

          return ListTile(
            leading: Checkbox(
              value: zadatak.zavrsen,
              onChanged: (vrijednost) {
                promijeniZavrsen(zadatak);
              },
            ),
            title: Text(zadatak.naslov),
            subtitle: Text(
              zadatak.nazivKategorije ?? '',
              style: TextStyle(color: pretvoriBoju(zadatak.boja)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                obrisiZadatak(zadatak);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: otvoriDijalog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ================= PROZOR ZA NOVI ZADATAK =================

class NoviZadatakDijalog extends StatefulWidget {
  final List<Kategorija> kategorije;

  const NoviZadatakDijalog({super.key, required this.kategorije});

  @override
  State<NoviZadatakDijalog> createState() => _NoviZadatakDijalogState();
}

class _NoviZadatakDijalogState extends State<NoviZadatakDijalog> {
  var naslovKontroler = TextEditingController();
  int? odabranaKategorija;

  @override
  void initState() {
    super.initState();
    odabranaKategorija = widget.kategorije.first.id;
  }

  @override
  void dispose() {
    naslovKontroler.dispose();
    super.dispose();
  }

  // >>> DAO: INSERT
  Future<void> spremi() async {
    var naslov = naslovKontroler.text.trim();
    if (naslov.isEmpty || odabranaKategorija == null) {
      return;
    }

    var noviZadatak = Zadatak(naslov: naslov, kategorijaId: odabranaKategorija!);
    await ZadatakDAO().dodaj(noviZadatak);

    if (!mounted) return;
    Navigator.pop(context, true); // zatvori prozor i javi da je dodano
  }

  @override
  Widget build(BuildContext context) {
    // Stavke padajućeg izbornika – jedna po kategoriji
    List<DropdownMenuItem<int>> stavke = [];
    for (var kategorija in widget.kategorije) {
      stavke.add(DropdownMenuItem(
        value: kategorija.id,
        child: Text(kategorija.naziv),
      ));
    }

    return AlertDialog(
      title: const Text('Novi zadatak'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: naslovKontroler,
            decoration: const InputDecoration(labelText: 'Naslov'),
          ),
          const SizedBox(height: 16),
          DropdownButton<int>(
            value: odabranaKategorija,
            isExpanded: true,
            items: stavke,
            onChanged: (vrijednost) {
              setState(() {
                odabranaKategorija = vrijednost;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Odustani'),
        ),
        FilledButton(
          onPressed: spremi,
          child: const Text('Spremi'),
        ),
      ],
    );
  }
}