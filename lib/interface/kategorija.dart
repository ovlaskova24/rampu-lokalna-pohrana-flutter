// Jedan redak tablice kategorija
class Kategorija {
  final int? id;      // ? jer nova kategorija još nema ID, dodijeli ga baza
  final String naziv;
  final String boja;

  Kategorija({
    this.id,
    required this.naziv,
    required this.boja});
}