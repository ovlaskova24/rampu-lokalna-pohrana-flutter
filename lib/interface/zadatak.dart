// Jedan redak tablice "zadatak"
class Zadatak {
  final int? id;
  final String naslov;
  final bool zavrsen;
  final int kategorijaId;

  // Popunjeno samo kad zadatak dohvatimo spojem s tablicom kategorija
  final String? nazivKategorije;
  final String? boja;

  Zadatak({
    this.id,
    required this.naslov,
    this.zavrsen = false,
    required this.kategorijaId,
    this.nazivKategorije,
    this.boja,
  });
}