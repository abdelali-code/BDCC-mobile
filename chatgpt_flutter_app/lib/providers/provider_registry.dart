import 'ai_provider.dart';
import 'gemini_provider.dart';
import 'openai_compatible_provider.dart';

/// Registre central de tous les fournisseurs d'IA disponibles dans
/// l'application. Pour ajouter un nouveau fournisseur compatible avec le
/// format "OpenAI Chat Completions", il suffit d'ajouter une entrée ici.
final List<AiProvider> aiProviders = [
  const OpenAICompatibleProvider(
    id: 'groq',
    displayName: 'Groq',
    description:
        'Modèles Llama / Mixtral ultra-rapides. Offre gratuite généreuse : '
        'idéal pour tester sans payer.',
    endpoint: 'https://api.groq.com/openai/v1/chat/completions',
    defaultModel: 'llama-3.3-70b-versatile',
    suggestedModels: [
      'llama-3.3-70b-versatile',
      'llama-3.1-8b-instant',
      'mixtral-8x7b-32768',
    ],
    apiKeyUrl: 'https://console.groq.com/keys',
    isFree: true,
  ),
  GeminiProvider(),
  const OpenAICompatibleProvider(
    id: 'openrouter',
    displayName: 'OpenRouter',
    description:
        'Passerelle vers de nombreux modèles ; plusieurs modèles gratuits '
        '(suffixe ":free").',
    endpoint: 'https://openrouter.ai/api/v1/chat/completions',
    defaultModel: 'meta-llama/llama-3.1-8b-instruct:free',
    suggestedModels: [
      'meta-llama/llama-3.1-8b-instruct:free',
      'google/gemma-2-9b-it:free',
      'mistralai/mistral-7b-instruct:free',
    ],
    apiKeyUrl: 'https://openrouter.ai/keys',
    isFree: true,
    extraHeaders: {
      'HTTP-Referer': 'https://flutter-chatbot.local',
      'X-Title': 'Flutter ChatBot',
    },
  ),
  const OpenAICompatibleProvider(
    id: 'openai',
    displayName: 'OpenAI (ChatGPT)',
    description:
        'GPT-4o mini, GPT-3.5 — payant, quelques crédits gratuits à l\'inscription.',
    endpoint: 'https://api.openai.com/v1/chat/completions',
    defaultModel: 'gpt-4o-mini',
    suggestedModels: ['gpt-4o-mini', 'gpt-3.5-turbo', 'gpt-4o'],
    apiKeyUrl: 'https://platform.openai.com/api-keys',
    isFree: false,
  ),
  const OpenAICompatibleProvider(
    id: 'grok',
    displayName: 'xAI Grok',
    description:
        'Modèle Grok de xAI — nécessite un compte x.ai avec facturation active.',
    endpoint: 'https://api.x.ai/v1/chat/completions',
    defaultModel: 'grok-2-latest',
    suggestedModels: ['grok-2-latest', 'grok-beta'],
    apiKeyUrl: 'https://console.x.ai',
    isFree: false,
  ),
];

AiProvider providerById(String id) =>
    aiProviders.firstWhere((p) => p.id == id, orElse: () => aiProviders.first);
