import 'package:flutter/material.dart';

import 'jeu_prepa_page.dart';

/// Ouvre tout de suite l’écran de préparation.
///
/// Les images se préchargent en arrière-plan sur [JeuPrepaPage] puis au tap sur
/// « Jouer », pour ne pas bloquer la navigation depuis l’accueil.
///
/// Fichier dédié pour permettre un `import … deferred` depuis l’accueil :
/// le code du jeu n’est chargé qu’au premier accès, ce qui allège le démarrage.
void ouvrirPreparationJeu(BuildContext context) {
  Navigator.push<void>(
    context,
    MaterialPageRoute<void>(builder: (context) => const JeuPrepaPage()),
  );
}
