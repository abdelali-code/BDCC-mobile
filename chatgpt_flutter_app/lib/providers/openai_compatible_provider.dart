import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import 'ai_provider.dart';

/// Implémentation générique pour tous les fournisseurs compatibles avec le
/// format "OpenAI Chat Completions" (OpenAI, Groq, OpenRouter, xAI Grok...).
/// La plupart des fournisseurs d'IA du marché exposent aujourd'hui une API
/// compatible avec ce format, ce qui évite de dupliquer le code réseau.
class OpenAICompatibleProvider implements AiProvider {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String description;
  @override
  final String defaultModel;
  @override
  final List<String> suggestedModels;
  @override
  final String apiKeyUrl;
  @override
  final bool isFree;

  final String endpoint;
  final Map<String, String> extraHeaders;

  const OpenAICompatibleProvider({
    required this.id,
    required this.displayName,
    required this.description,
    required this.endpoint,
    required this.defaultModel,
    required this.suggestedModels,
    required this.apiKeyUrl,
    this.isFree = false,
    this.extraHeaders = const {},
  });

  @override
  Future<String> sendMessage({
    required String apiKey,
    required String model,
    required String systemPrompt,
    required List<ChatMessage> history,
  }) async {
    if (apiKey.isEmpty) {
      throw ProviderException(
          'Clé API manquante pour $displayName. Ajoutez-la depuis les paramètres.');
    }

    final messages = [
      {'role': 'system', 'content': systemPrompt},
      ...history.map((m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.text,
          }),
    ];

    try {
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
              ...extraHeaders,
            },
            body: jsonEncode({
              'model': model,
              'messages': messages,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        return (data['choices'][0]['message']['content'] as String).trim();
      }

      final errorMessage =
          data['error']?['message'] ?? data['error'] ?? 'Erreur inconnue';
      throw ProviderException(
          '$displayName — erreur (${response.statusCode}) : $errorMessage');
    } on ProviderException {
      rethrow;
    } catch (e) {
      throw ProviderException(
          '$displayName — impossible de contacter le serveur : $e');
    }
  }
}
