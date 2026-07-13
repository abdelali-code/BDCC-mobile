import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatServiceException implements Exception {
  final String message;
  ChatServiceException(this.message);
  @override
  String toString() => message;
}

/// Service qui communique avec l'API ChatGPT (OpenAI Chat Completions).
/// Correspond à la méthode "API REST" vue dans le cours (Stockage de
/// Données Distant), utilisée ici pour récupérer les réponses du modèle.
class ChatService {
  static const _endpoint = 'https://api.openai.com/v1/chat/completions';
  final String apiKey;
  final String model;

  ChatService({required this.apiKey, this.model = 'gpt-3.5-turbo'});

  /// Envoie l'historique de conversation et retourne la réponse du modèle.
  Future<String> sendMessage(List<Map<String, String>> conversation) async {
    if (apiKey.isEmpty) {
      throw ChatServiceException(
          'Clé API manquante. Ajoutez-la depuis les paramètres.');
    }

    try {
      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode({
              'model': model,
              'messages': conversation,
              'temperature': 0.7,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = data['error']?['message'] ?? 'Erreur inconnue';
        throw ChatServiceException(
            'Erreur API (${response.statusCode}): $errorMessage');
      }
    } on ChatServiceException {
      rethrow;
    } catch (e) {
      throw ChatServiceException('Impossible de contacter le serveur : $e');
    }
  }
}
