/// Fruits disponibles pour le jeu de réflexe (image gagnante au choix).
class FruitJeu {
  const FruitJeu({required this.chemin, required this.nom});

  final String chemin;
  final String nom;
}

/// Ordre cohérent avec les assets du projet.
const List<FruitJeu> fruitsJeuDisponibles = [
  FruitJeu(chemin: 'assets/avo.jpg', nom: 'Avocat'),
  FruitJeu(chemin: 'assets/ban.jpg', nom: 'Banane'),
  FruitJeu(chemin: 'assets/kiw.jpg', nom: 'Kiwi'),
  FruitJeu(chemin: 'assets/mag.jpg', nom: 'Mangue'),
  FruitJeu(chemin: 'assets/mand.jpg', nom: 'Mandarine'),
  FruitJeu(chemin: 'assets/mel.jpg', nom: 'Melon'),
  FruitJeu(chemin: 'assets/pas.jpg', nom: 'Fruit de la passion'),
  FruitJeu(chemin: 'assets/pec.jpg', nom: 'Pêche'),
  FruitJeu(chemin: 'assets/rai.jpg', nom: 'Raisin'),
];

/// Les 8 images « perdantes » pour une grille 3×3 (le fruit cible est exclu).
List<String> imagesPerdantesPour(String cheminFruitGagnant) {
  return fruitsJeuDisponibles
      .map((f) => f.chemin)
      .where((p) => p != cheminFruitGagnant)
      .toList();
}
