// Jedan redak tablice "podzadatak" (slabi entitet)
class Podzadatak {
  final int zadatakId;   // dio primarnog ključa
  final int redniBroj;   // dio primarnog ključa
  final String opis;
  final bool obavljen;

  // Popunjeno kad podzadatak dohvatimo spojem s tablicom zadatak
  final String? naslovZadatka;

  Podzadatak({
    required this.zadatakId,
    required this.redniBroj,
    required this.opis,
    this.obavljen = false,
    this.naslovZadatka,
  });
}