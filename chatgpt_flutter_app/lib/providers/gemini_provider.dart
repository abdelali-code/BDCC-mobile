import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import 'ai_provider.dart';

/// Implémentation pour Google Gemini, dont le format d'API diffère du
/// standard "OpenAI Chat Completions" (d'où une classe dédiée plutôt que
/// [OpenAICompatibleProvider]).
class GeminiProvider implements AiProvider {
  @override
  String get id => 'gemini';
  @override
  String get displayName => 'Google Gemini';
  @override
  String get description =>
      'Modèles Gemini de Google — palier gratuit généreux via Google AI Studio.';
  @override
  String get defaultModel => 'gemini-1.5-flash';
  @override
  List<String> get suggestedModels => const [
        'gemini-1.5-flash',
        'gemini-1.5-pro',
        'gemini-2.0-flash',
      ];
  @override
  String get apiKeyUrl => 'https://aistudio.google.com/apikey';
  @override
  bool get isFree => true;

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

    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey');

    final contents = history
        .map((m) => {
              'role': m.isUser ? 'user' : 'model',
              'parts': [
                {'text': m.text}
              ],
            })
        .toList();

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'systemInstruction': {
                'parts': [
                  {'text': systemPrompt}
                ],
              },
              'contents': contents,
            }),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200) {
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        return text.trim();
      }

      final errorMessage = data['error']?['message'] ?? 'Erreur inconnue';
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
