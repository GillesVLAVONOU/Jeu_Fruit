import 'package:shared_preferences/shared_preferences.dart';

/// Persistance du meilleur score du jeu de réflexe (0 si jamais enregistré).
class MeilleurScoreStorage {
  MeilleurScoreStorage._();

  static const _cle = 'jeu_meilleur_score';

  static Future<int> lire() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_cle) ?? 0;
  }

  static Future<void> ecrire(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_cle, score);
  }

  static Future<void> effacer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cle);
  }
}
