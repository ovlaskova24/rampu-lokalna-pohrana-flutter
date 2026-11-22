import 'dart:io';

import 'package:path_provider/path_provider.dart';

// IZOLIRANA POHRANA, datoteka u privatnoj mapi aplikacije.
// Drugim aplikacijama ova mapa nije dostupna.
class DatotecnaPohrana {
  Future<File> _datoteka() async {
    var mapa = await getApplicationDocumentsDirectory();
    return File('${mapa.path}/biljeska.txt');
  }

  Future<String> putanja() async {
    var datoteka = await _datoteka();
    return datoteka.path;
  }

  Future<void> spremi(String tekst) async {
    var datoteka = await _datoteka();
    await datoteka.writeAsString(tekst);
  }

  Future<String> ucitaj() async {
    var datoteka = await _datoteka();
    if (await datoteka.exists()) {
      return await datoteka.readAsString();
    }
    return '';
  }
}