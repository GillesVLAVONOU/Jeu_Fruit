# Projet Flutter – Mini Jeu

## Membres du groupe

- CAPO-CHICHI Guy-Marie
- AKOHA Hihommey Mathieu
- VLAVONOU Gilles

## Thème choisi

**Fruits**

Les visuels du jeu utilisent neuf fruits : Avocat, Banane, Kiwi, Mangue, Mandarine, Melon, Pastèque, Pêche et Raisin (fichiers image dans `assets/`, configurés dans `lib/jeu_fruits_config.dart`).

## Description du jeu

Avant la partie, l’écran **Préparer la partie** permet de choisir, dans une liste déroulante, le **fruit cible** pour toute la session.

Pendant le jeu (**Jeu de Réflexe**), une grille **3 × 3** affiche neuf images. Une case choisie au hasard contient le fruit demandé ; les huit autres montrent les autres fruits, dans un ordre mélangé. Le joueur doit **taper sur l’image du bon fruit**.

- **Score** : +5 par bonne réponse, −2 par erreur (le score ne descend pas en dessous de 0).
- **Vies** : 5 cœurs au départ ; une erreur enlève une vie. À 0 vie, la **partie se termine**.
- **Changement automatique** : un minuteur mélange à nouveau la grille après un délai qui **accélère** quand le score augmente (5 s, puis 3 s à partir de 50 points, puis 1 s à partir de 150 points).
- **Fin de partie** : dialogue avec le score de la partie, le **meilleur score enregistré** (stocké sur l’appareil), message **Nouveau record** si applicable, boutons **Recommencer** et remise à zéro du meilleur score.

L’accueil propose aussi les écrans **À propos** et **Contact** (message par e-mail via `url_launcher`).

## Modifications réalisées

Par rapport à un squelette de mini-jeu « cliquer la bonne image parmi 9 » :

- **Thème et contenu** : jeu centré sur les **fruits**, avec liste de neuf fruits et chemins d’assets dédiés (`jeu_fruits_config.dart`).
- **Écran de préparation** (`jeu_prepa_page.dart`) : choix du fruit cible avant de lancer la partie.
- **Règles étendues** : système de **vies** (5), **pénalité** sur erreur, score plancher à 0, **rafraîchissement automatique** de la grille avec **vitesses variables** selon le score.
- **Score** : affichage du score en direct, **meilleur score persistant** avec `shared_preferences` (`meilleur_score_storage.dart`), réinitialisation depuis le menu de la barre d’outils ou depuis l’écran de fin de partie.
- **Retour utilisateur** : vibration (`HapticFeedback`) et son d’alerte sur mauvais clic ; dialogue **Partie terminée** avec opacité sur la grille pendant l’overlay.
- **Interface** : thème **violet / dégradé** (`app_gradient_background.dart`, `main.dart`), cartes arrondies pour les images, texte lisible sur fond (ombres portées), accueil avec carte mise en avant « Jeu de réflexe » et menu structuré.
- **Performance et navigation** : **préchargement** des images avant / au lancement du jeu (`precacheImage`), `gaplessPlayback` et dimensions de cache pour les tuiles ; **import différé** du module jeu depuis l’accueil (`deferred` dans `home_page.dart`) pour alléger le démarrage.
- **Pages annexes** : **À propos** (texte projet, image, lien LinkedIn) et **Contact** (formulaire vers une adresse e-mail configurable).

## Difficultés rencontrées

- **Gestion des images** : neuf fichiers à déclarer, éviter les saccades au changement de tour, et limiter l’usage mémoire sur la grille (décodage à taille raisonnable).
- **Logique du jeu** : placer exactement **une** case gagnante et **huit** images perdantes distinctes du fruit cible, avec position aléatoire ; relancer le **timer** quand la durée change (passage de palier de score).
- **État asynchrone** : lire / écrire le meilleur score sans erreur après `await` (vérifier `mounted` avant `setState`).
- **Mise en page** : aligner **cœurs**, **score** et **consigne** sans chevauchement ; grille centrée avec largeur max (~350 px) sur petits écrans.
- **Cohérence visuelle** : éviter un flash de surface claire entre les écrans Material 3 en harmonisant `ColorScheme`, `scaffoldBackgroundColor` et transitions de page.

## Solutions ou apprentissages

- Centraliser la liste des fruits et la fonction « images perdantes » dans **`jeu_fruits_config.dart`** pour une seule source de vérité.
- Utiliser **`precacheTousLesAssetsJeu`** sur la page de préparation et avant d’ouvrir `JeuPage` ; pour chaque tuile, **`cacheWidth` / `cacheHeight`** adaptés au `devicePixelRatio`.
- Annuler et recréer le **`Timer.periodic`** quand **`_dureeChangementAuto`** change (nouvelle période).
- Persistance simple et fiable avec **`SharedPreferences`** encapsulée dans `MeilleurScoreStorage`.
- **`Stack` + `Positioned`** pour les cœurs et l’overlay de fin de partie ; **`AbsorbPointer`** sur la grille quand la partie est terminée.

## Améliorations possibles

- **Classement** ou synchronisation du meilleur score (backend ou compte utilisateur).
- **Niveaux de difficulté** (moins de temps, plus de fruits similaires visuellement, grille 4×4).
- **Effets sonores** distincts pour bon / mauvais clic et **musique** d’ambiance optionnelle.
- **Animations** (flip des cartes, confetti sur nouveau record).
- **Accessibilité** : tailles de police dynamiques, labels sémantiques pour les images.
- **Tests automatisés** (widget / logique de score et de fin de partie).
