import 'package:flutter/material.dart';

/// Dégradé violet utilisé comme fond sur les écrans de l'application.
const BoxDecoration kAppPurpleGradientDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4A148C),
      Color(0xFF7B1FA2),
      Color(0xFF9C27B0),
      Color(0xFF6A1B9A),
    ],
    stops: [0.0, 0.35, 0.65, 1.0],
  ),
);

class PurpleGradientBackground extends StatelessWidget {
  const PurpleGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(decoration: kAppPurpleGradientDecoration, child: child);
  }
}
