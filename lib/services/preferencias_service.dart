import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences: só dados NÃO sensíveis
class PreferenciasService {
  static const _ultimaBusca = 'ultima_busca';

  // lê
  Future<String> lerUltimaBusca() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_ultimaBusca) ?? '';
    } catch (_) {
      return '';
    }
  }

  // grava
  Future<void> salvarUltimaBusca(String texto) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_ultimaBusca, texto);
    } catch (_) {
    }
  }
}