import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Odabir "motora": u Chromeu SQLite kroz WebAssembly, na Androidu nativni SQLite
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // 2) Otvaranje (i po potrebi kreiranje) baze
  final db = await openDatabase(
    'test.db',
    version: 1,
    onCreate: (db, version) async {
      // izvršava se SAMO kad baza još ne postoji
      await db.execute('''
        CREATE TABLE categories(
          category_id   INTEGER PRIMARY KEY AUTOINCREMENT,
          category_name TEXT NOT NULL,
          color         TEXT NOT NULL
        )
      ''');
    },
  );

  // 3) Upis jednog retka
  await db.insert('categories', {'category_name': 'RAMPU', 'color': '#000080'});

  // 4) Selekcija svih redaka
  final rows = await db.query('categories');
  print('Broj redaka: ${rows.length}');
  print(rows);

  runApp(MyApp(brojRedaka: rows.length));   
}


class MyApp extends StatelessWidget {
  final int brojRedaka;

  const MyApp({super.key, required this.brojRedaka});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokalna pohrana',
      home: Scaffold(
        appBar: AppBar(title: const Text('Test baze')),
        body: Center(
          child: Text(
            'U tablici categories ima $brojRedaka redaka',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}