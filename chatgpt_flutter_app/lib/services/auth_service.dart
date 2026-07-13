import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/provider_registry.dart';

/// Service d'authentification et de préférences, basé sur SharedPreferences
/// (cf. cours : Stockage de Données Local -> Shared Preferences).
/// Gère aussi le stockage multi-fournisseurs : une clé API et un modèle
/// choisi par fournisseur, plus le fournisseur actuellement actif.
class AuthService {
  static const _kUsername = 'username';
  static const _kLoggedIn = 'is_logged_in';
  static const _kApiKeys = 'api_keys'; // JSON: { providerId: apiKey }
  static const _kModels = 'selected_models'; // JSON: { providerId: model }
  static const _kSelectedProvider = 'selected_provider';

  // --- Session ---

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUsername);
  }

  Future<void> login({required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsername, username);
    await prefs.setBool(_kLoggedIn, true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    // On garde volontairement le nom, les clés API et les modèles choisis
    // pour permettre une reconnexion rapide.
  }

  // --- Clés API par fournisseur ---

  Future<Map<String, String>> getApiKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kApiKeys);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw) as Map);
  }

  Future<String?> getApiKey(String providerId) async {
    final keys = await getApiKeys();
    return keys[providerId];
  }

  Future<void> saveApiKey(String providerId, String key) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = await getApiKeys();
    keys[providerId] = key;
    await prefs.setString(_kApiKeys, jsonEncode(keys));
  }

  // --- Modèle choisi par fournisseur ---

  Future<Map<String, String>> _getModels() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kModels);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw) as Map);
  }

  Future<String> getModel(String providerId) async {
    final models = await _getModels();
    return models[providerId] ?? providerById(providerId).defaultModel;
  }

  Future<void> saveModel(String providerId, String model) async {
    final prefs = await SharedPreferences.getInstance();
    final models = await _getModels();
    models[providerId] = model;
    await prefs.setString(_kModels, jsonEncode(models));
  }

  // --- Fournisseur actuellement actif ---

  Future<String> getSelectedProviderId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSelectedProvider) ?? aiProviders.first.id;
  }

  Future<void> setSelectedProviderId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedProvider, id);
  }
}
