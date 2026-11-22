import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'aplikacija/baza_ekran.dart';
import 'pohrana/postavke.dart';

Future<void> main() async {
  // Flutter mora biti spreman prije nego koristimo pluginove (bazu, datoteke, postavke)
  WidgetsFlutterBinding.ensureInitialized();

  // U Chromeu koristimo SQLite preveden u WebAssembly, na mobitelu pravi SQLite
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // SharedPreferences: brojimo koliko je puta aplikacija pokrenuta
  await Postavke().povecajBrojPokretanja();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lokalna pohrana',
      home: BazaEkran(),
    );
  }
}