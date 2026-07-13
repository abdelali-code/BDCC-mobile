import 'package:shared_preferences/shared_preferences.dart';

/// Service d'authentification simplifié basé sur SharedPreferences
/// (cf. cours: Stockage de Données Local -> Shared Preferences).
/// Stocke localement le nom d'utilisateur, l'état de connexion
/// et la clé API OpenAI.
class AuthService {
  static const _kUsername = 'username';
  static const _kApiKey = 'openai_api_key';
  static const _kLoggedIn = 'is_logged_in';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUsername);
  }

  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kApiKey);
  }

  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kApiKey, apiKey);
  }

  Future<void> login({required String username, String? apiKey}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsername, username);
    await prefs.setBool(_kLoggedIn, true);
    if (apiKey != null && apiKey.isNotEmpty) {
      await prefs.setString(_kApiKey, apiKey);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    // On garde volontairement le nom et la clé API pour une reconnexion rapide.
  }
}
