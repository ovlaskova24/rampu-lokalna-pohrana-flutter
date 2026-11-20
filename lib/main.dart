import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'podaci/upravitelj_baze.dart';

Future<void> main() async {
  // Flutter mora biti spreman prije nego koristimo pluginove (bazu, assets)
  WidgetsFlutterBinding.ensureInitialized();

  // U Chromeu koristimo SQLite preveden u WebAssembly, na mobitelu pravi SQLite
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // PRIVREMENI TEST: otvori bazu i prebroji retke u obje tablice
  Database baza = await UpraviteljBaze.instanca.baza;
  List<Map<String, Object?>> kategorije = await baza.query('kategorija');
  List<Map<String, Object?>> zadaci = await baza.query('zadatak');

  runApp(MyApp(
    brojKategorija: kategorije.length,
    brojZadataka: zadaci.length,
  ));
}

// PRIVREMENI EKRAN: samo ispisuje dva broja
class MyApp extends StatelessWidget {
  final int brojKategorija;
  final int brojZadataka;

  const MyApp({
    super.key,
    required this.brojKategorija,
    required this.brojZadataka,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokalna pohrana',
      home: Scaffold(
        appBar: AppBar(title: const Text('Test baze')),
        body: Center(
          child: Text(
            'Kategorija: $brojKategorija\nZadataka: $brojZadataka',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}