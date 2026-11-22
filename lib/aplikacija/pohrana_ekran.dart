import 'package:material_ui/material_ui.dart';

import '../pohrana/datotecna_pohrana.dart';
import '../pohrana/postavke.dart';

class PohranaEkran extends StatefulWidget {
  const PohranaEkran({super.key});

  @override
  State<PohranaEkran> createState() => _PohranaEkranState();
}

class _PohranaEkranState extends State<PohranaEkran> {
  var datotecnaPohrana = DatotecnaPohrana();
  var postavke = Postavke();

  var biljeskaKontroler = TextEditingController();
  var imeKontroler = TextEditingController();

  String putanja = '';
  int brojPokretanja = 0;

  @override
  void initState() {
    super.initState();
    ucitajSve();
  }

  @override
  void dispose() {
    biljeskaKontroler.dispose();
    imeKontroler.dispose();
    super.dispose();
  }

  Future<void> ucitajSve() async {
    var p = await datotecnaPohrana.putanja();
    var ime = await postavke.dohvatiIme();
    var broj = await postavke.dohvatiBrojPokretanja();

    setState(() {
      putanja = p;
      imeKontroler.text = ime;
      brojPokretanja = broj;
    });
  }

  //IZOLIRANA POHRANA: upis u datoteku
  Future<void> spremiBiljesku() async {
    await datotecnaPohrana.spremi(biljeskaKontroler.text);
    poruka('Bilješka spremljena u datoteku');
  }

  //IZOLIRANA POHRANA: čitanje iz datoteke
  Future<void> ucitajBiljesku() async {
    var tekst = await datotecnaPohrana.ucitaj();
    setState(() {
      biljeskaKontroler.text = tekst;
    });
    poruka('Bilješka učitana iz datoteke');
  }

  //SHARED PREFERENCES: upis
  Future<void> spremiIme() async {
    await postavke.spremiIme(imeKontroler.text);
    poruka('Ime spremljeno u SharedPreferences');
  }

  void poruka(String tekst) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tekst)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pohrana')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- Izolirana pohrana ----------
          const Text(
            'Izolirana pohrana – datoteka',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Putanja: $putanja',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          TextField(
            controller: biljeskaKontroler,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Bilješka'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilledButton(
                onPressed: spremiBiljesku,
                child: const Text('Spremi'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: ucitajBiljesku,
                child: const Text('Učitaj'),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ---------- SharedPreferences ----------
          const Text(
            'SharedPreferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Aplikacija je pokrenuta $brojPokretanja puta'),
          TextField(
            controller: imeKontroler,
            decoration: const InputDecoration(labelText: 'Ime korisnika'),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: spremiIme,
              child: const Text('Spremi ime'),
            ),
          ),
        ],
      ),
    );
  }
}