import '../models/message.dart';

/// Exception levée par un fournisseur IA en cas d'erreur (réseau, clé
/// invalide, quota dépassé...).
class ProviderException implements Exception {
  final String message;
  ProviderException(this.message);
  @override
  String toString() => message;
}

/// Interface commune à tous les fournisseurs d'IA (OpenAI, Grok, Groq,
/// Gemini, OpenRouter...). Pour ajouter un nouveau fournisseur, il suffit
/// d'implémenter cette interface et de l'ajouter au registre — aucune autre
/// partie de l'application n'a besoin d'être modifiée.
abstract class AiProvider {
  /// Identifiant technique stable (utilisé comme clé de stockage local).
  String get id;

  /// Nom affiché à l'utilisateur.
  String get displayName;

  /// Courte description affichée dans l'écran des paramètres.
  String get description;

  /// Modèle utilisé par défaut si l'utilisateur n'en choisit pas un autre.
  String get defaultModel;

  /// Quelques modèles suggérés pour ce fournisseur.
  List<String> get suggestedModels;

  /// Lien où obtenir une clé API.
  String get apiKeyUrl;

  /// true si ce fournisseur propose un palier gratuit exploitable pour tester.
  bool get isFree;

  /// Envoie l'historique de conversation et retourne la réponse texte du modèle.
  Future<String> sendMessage({
    required String apiKey,
    required String model,
    required String systemPrompt,
    required List<ChatMessage> history,
  });
}
