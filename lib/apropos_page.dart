import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_gradient_background.dart';

class ApropoPage extends StatelessWidget {
  const ApropoPage({super.key});

  static const TextStyle _texte = TextStyle(
    color: Colors.white,
    fontSize: 16,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A148C),
      appBar: AppBar(title: const Text('À propos')),
      body: PurpleGradientBackground(
        child: SizedBox.expand(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 220,
                      child: Image.asset('assets/mand.jpg', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ce jeu est génial',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ce jeu est un prototype de cours de programmation informatique avec le langage Flutter.',
                    style: _texte,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A148C),
                    ),
                    onPressed: () async {
                      final Uri url = Uri.parse(
                        'https://www.linkedin.com/in/gilles-vlavonou-512a843a1',
                      );
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: const Text('Voir LinkedIn'),
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
