import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const Color purpleDeep = Color(0xFF4A148C);
  const Color purpleMid = Color(0xFF5E1780);

  // Surfaces alignées sur le fond de l’app : la surface M3 par défaut est très claire
  // et apparaît un instant pendant les transitions (flash blanc).
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF7B1FA2),
  ).copyWith(
    surface: purpleDeep,
    surfaceContainerHighest: purpleMid,
    surfaceContainerHigh: Color(0xFF56208A),
    surfaceContainer: Color(0xFF4E1A82),
    surfaceContainerLow: purpleDeep,
    surfaceContainerLowest: Color(0xFF3D0F75),
    surfaceTint: Colors.transparent,
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFFE1BEE7),
  );

  runApp(
    MaterialApp(
      title: 'App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: purpleDeep,
        appBarTheme: const AppBarTheme(
          backgroundColor: purpleDeep,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // Zoom Android (M3) peut brièvement montrer des bords non peints ; le slide
        // type Cupertino reste cohérent avec un fond violet partout.
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      // Fichier sous le Navigator si une frame laisse transparaître le conteneur.
      builder: (context, child) {
        return ColoredBox(
          color: purpleDeep,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomePage(),
    ),
  );
}
