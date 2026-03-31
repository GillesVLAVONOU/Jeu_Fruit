import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_gradient_background.dart';
import 'jeu_fruits_config.dart';
import 'meilleur_score_storage.dart';

class JeuPage extends StatefulWidget {
  const JeuPage({
    super.key,
    required this.imageGagnante,
    required this.nomFruitCible,
  });

  /// Image à cliquer pour marquer des points.
  final String imageGagnante;

  /// Libellé affiché au joueur (ex. « Avocat »).
  final String nomFruitCible;

  /// Précharge toutes les images de fruits (appel idéal avant d’ouvrir la préparation ou le jeu).
  static Future<void> precacheTousLesAssetsJeu(BuildContext context) async {
    await Future.wait(
      fruitsJeuDisponibles.map(
        (f) => precacheImage(AssetImage(f.chemin), context),
      ),
    );
  }

  @override
  State<JeuPage> createState() => _JeuPageState();
}

class _JeuPageState extends State<JeuPage> {
  int positionGagnante = 0;
  int score = 0;
  Timer? _timer;

  /// Vies restantes (5 cœurs au départ). Un clic sur une image perdante enlève une vie.
  int _vies = 5;

  bool _partieTerminee = false;

  /// Meilleur score persisté (0 tant qu'aucune partie n'a été enregistrée).
  int _meilleurScore = 0;

  /// Vrai si la partie qui vient de se terminer a battu l'ancien record.
  bool _nouveauRecord = false;

  // Liste qui contiendra l'ordre des images à chaque tour
  List<String> imagesMelangees = [];

  /// 0 = lent, 1 = plus rapide dès score ≥ 50, 2 = encore plus rapide dès score ≥ 150
  int get _phaseVitesse {
    if (score < 50) return 0;
    if (score < 150) return 1;
    return 2;
  }

  Duration get _dureeChangementAuto {
    switch (_phaseVitesse) {
      case 0:
        return const Duration(seconds: 5);
      case 1:
        return const Duration(seconds: 3);
      default:
        return const Duration(seconds: 1);
    }
  }

  /// Texte blanc lisible sur le fond dégradé.
  TextStyle _styleTexteSurFond({double fontSize = 16, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.white,
      shadows: const [
        Shadow(blurRadius: 6, color: Colors.black54, offset: Offset(0, 1)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    nouveauJeu();
    _demarrerTimerChangementAuto();
    unawaited(_chargerMeilleurScore());
  }

  Future<void> _chargerMeilleurScore() async {
    final m = await MeilleurScoreStorage.lire();
    if (!mounted) return;
    setState(() => _meilleurScore = m);
  }

  void _demarrerTimerChangementAuto() {
    _timer?.cancel();
    if (_partieTerminee) return;
    _timer = Timer.periodic(_dureeChangementAuto, (_) {
      if (!mounted || _partieTerminee) return;
      nouveauJeu();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void nouveauJeu() {
    if (_partieTerminee) return;
    setState(() {
      imagesMelangees = List.from(imagesPerdantesPour(widget.imageGagnante));
      positionGagnante = Random().nextInt(9) + 1;
    });
  }

  Future<void> _terminerPartie() async {
    _timer?.cancel();
    if (!mounted) return;

    final scorePartie = score;
    final ancienMeilleur = await MeilleurScoreStorage.lire();
    var meilleur = ancienMeilleur;
    var battu = false;

    if (scorePartie > ancienMeilleur) {
      await MeilleurScoreStorage.ecrire(scorePartie);
      meilleur = scorePartie;
      battu = true;
    }

    if (!mounted) return;
    setState(() {
      _partieTerminee = true;
      _meilleurScore = meilleur;
      _nouveauRecord = battu;
    });
  }

  Future<void> _reinitialiserMeilleurScore() async {
    await MeilleurScoreStorage.effacer();
    if (!mounted) return;
    setState(() {
      _meilleurScore = 0;
      if (_partieTerminee) _nouveauRecord = false;
    });
  }

  void _recommencer() {
    setState(() {
      _partieTerminee = false;
      _nouveauRecord = false;
      _vies = 5;
      score = 0;
      imagesMelangees = List.from(imagesPerdantesPour(widget.imageGagnante));
      positionGagnante = Random().nextInt(9) + 1;
    });
    _demarrerTimerChangementAuto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C),
      appBar: AppBar(
        title: const Text('Jeu de Réflexe'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Options',
            itemBuilder: (context) => const [
              PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.restart_alt),
                  title: Text('Réinitialiser le meilleur score'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            onSelected: (_) => unawaited(_reinitialiserMeilleurScore()),
          ),
        ],
      ),
      body: PurpleGradientBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 8,
              left: 12,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  _vies,
                  (_) => const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 22,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black26,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  // Espace sous la ligne des cœurs (coin haut-gauche) pour ne pas chevaucher le score.
                  const SizedBox(height: 48),
                  Text(
                    'Score : $score',
                    style: _styleTexteSurFond(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Meilleur score : $_meilleurScore',
                    style: _styleTexteSurFond(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!_partieTerminee)
                    Text(
                      'Cliquez sur « ${widget.nomFruitCible} » !',
                      style: _styleTexteSurFond(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: _partieTerminee,
                      child: Opacity(
                        opacity: _partieTerminee ? 0.35 : 1,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    carte(context, 1),
                                    carte(context, 2),
                                    carte(context, 3),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    carte(context, 4),
                                    carte(context, 5),
                                    carte(context, 6),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    carte(context, 7),
                                    carte(context, 8),
                                    carte(context, 9),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
            if (_partieTerminee)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Partie terminée',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            if (_nouveauRecord) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Nouveau record !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Text(
                              'Score de cette partie : $score',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Meilleur score enregistré : $_meilleurScore',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF4A148C),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _recommencer,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Recommencer'),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF4A148C),
                              ),
                              onPressed: () =>
                                  unawaited(_reinitialiserMeilleurScore()),
                              icon: const Icon(Icons.restart_alt, size: 20),
                              label: const Text('Remettre meilleur score à 0'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget carte(BuildContext context, int position) {
    // 3. Logique pour choisir l'image à afficher
    String imageAAfficher;
    if (position == positionGagnante) {
      imageAAfficher = widget.imageGagnante;
    } else {
      int indexImage = position > positionGagnante
          ? position - 2
          : position - 1;
      imageAAfficher = imagesMelangees[indexImage];
    }

    final dpr = MediaQuery.devicePixelRatioOf(context);
    // Grille max 350, ~3 colonnes, marges — taille decode réduite = moins de latence mémoire
    const maxGrid = 350.0;
    final cardLogical = (maxGrid - 40) / 3;
    final cachePx = (cardLogical * dpr).round();

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_partieTerminee) return;

          if (position == positionGagnante) {
            final phaseAvant = _phaseVitesse;
            setState(() => score += 5);
            nouveauJeu();
            if (phaseAvant != _phaseVitesse) {
              _demarrerTimerChangementAuto();
            }
          } else {
            HapticFeedback.heavyImpact();
            SystemSound.play(SystemSoundType.alert);
            final phaseAvant = _phaseVitesse;
            setState(() {
              score -= 2;
              if (score < 0) score = 0;
              _vies--;
            });
            if (_vies <= 0) {
              unawaited(_terminerPartie());
            } else {
              if (phaseAvant != _phaseVitesse) {
                _demarrerTimerChangementAuto();
              }
              nouveauJeu();
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            imageAAfficher,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
            cacheWidth: cachePx,
            cacheHeight: cachePx,
          ),
        ),
      ),
    );
  }
}
