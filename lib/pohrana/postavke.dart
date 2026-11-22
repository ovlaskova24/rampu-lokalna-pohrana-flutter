import 'package:shared_preferences/shared_preferences.dart';

// SHARED PREFERENCES, male vrijednosti po principu ključ - vrijednost.
class Postavke {
  var _prefs = SharedPreferencesAsync();

  Future<String> dohvatiIme() async {
    var ime = await _prefs.getString('ime_korisnika');
    if (ime == null) {
      return '';
    }
    return ime;
  }

  Future<void> spremiIme(String ime) async {
    await _prefs.setString('ime_korisnika', ime);
  }

  Future<int> dohvatiBrojPokretanja() async {
    var broj = await _prefs.getInt('broj_pokretanja');
    if (broj == null) {
      return 0;
    }
    return broj;
  }

  Future<void> povecajBrojPokretanja() async {
    var broj = await dohvatiBrojPokretanja();
    await _prefs.setInt('broj_pokretanja', broj + 1);
  }
}