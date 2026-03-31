import 'dart:async';

import 'package:flutter/material.dart';

import 'app_gradient_background.dart';
import 'jeu_fruits_config.dart';
import 'jeu_page.dart';

/// Écran avant la partie : choix du fruit à viser puis lancement du jeu.
class JeuPrepaPage extends StatefulWidget {
  const JeuPrepaPage({super.key});

  @override
  State<JeuPrepaPage> createState() => _JeuPrepaPageState();
}

class _JeuPrepaPageState extends State<JeuPrepaPage> {
  late FruitJeu _fruitChoisi;
  bool _precacheLance = false;
  bool _ouvertureJeuEnCours = false;

  @override
  void initState() {
    super.initState();
    _fruitChoisi = fruitsJeuDisponibles.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precacheLance) return;
    _precacheLance = true;
    unawaited(JeuPage.precacheTousLesAssetsJeu(context));
  }

  Future<void> _ouvrirJeu() async {
    if (_ouvertureJeuEnCours) return;
    setState(() => _ouvertureJeuEnCours = true);
    try {
      await JeuPage.precacheTousLesAssetsJeu(context);
      if (!mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) => JeuPage(
            imageGagnante: _fruitChoisi.chemin,
            nomFruitCible: _fruitChoisi.nom,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _ouvertureJeuEnCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Préparer la partie'),
      ),
      body: PurpleGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Jeu de réflexe',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black38,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choisissez le fruit à viser pendant la partie.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontSize: 16,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Material(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<FruitJeu>(
                          isExpanded: true,
                          value: _fruitChoisi,
                          dropdownColor: const Color(0xFF4A148C),
                          iconEnabledColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                          items: fruitsJeuDisponibles
                              .map(
                                (f) => DropdownMenuItem<FruitJeu>(
                                  value: f,
                                  child: Text(f.nom),
                                ),
                              )
                              .toList(),
                          onChanged: (f) {
                            if (f == null) return;
                            setState(() => _fruitChoisi = f);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _ouvertureJeuEnCours ? null : _ouvrirJeu,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A148C),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: _ouvertureJeuEnCours
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Color(0xFF4A148C),
                            ),
                          )
                        : const Text('Jouer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
