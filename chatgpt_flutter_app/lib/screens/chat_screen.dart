import 'package:flutter/material.dart';
import '../models/message.dart';
import '../providers/ai_provider.dart';
import '../providers/provider_registry.dart';
import '../services/auth_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authService = AuthService();
  final _messages = <ChatMessage>[];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isTyping = false;
  AiProvider _provider = aiProviders.first;
  String _model = aiProviders.first.defaultModel;
  String? _apiKey;

  @override
  void initState() {
    super.initState();
    _loadProviderConfig();
  }

  Future<void> _loadProviderConfig() async {
    final providerId = await _authService.getSelectedProviderId();
    _provider = providerById(providerId);
    _model = await _authService.getModel(providerId);
    _apiKey = await _authService.getApiKey(providerId);

    if (!mounted) return;
    setState(() {
      _messages.clear();
      _messages.add(
        ChatMessage(
          id: 'welcome',
          text: (_apiKey == null || _apiKey!.isEmpty)
              ? 'Bonjour ! Configurez une clé API depuis ⚙️ pour commencer '
                  '(essayez Groq ou Gemini, gratuits).'
              : 'Bonjour ! Je suis connecté à ${_provider.displayName} '
                  '($_model). Posez-moi une question 🙂',
          isUser: false,
        ),
      );
    });
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    if (_apiKey == null || _apiKey!.isEmpty) {
      _showSnack('Veuillez configurer votre clé API dans les paramètres.');
      _openSettings();
      return;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
    );

    setState(() {
      _messages.add(userMessage);
      _textController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // On exclut le message d'accueil local de l'historique envoyé à l'API.
    final history = _messages.where((m) => m.id != 'welcome').toList();

    try {
      final reply = await _provider.sendMessage(
        apiKey: _apiKey!,
        model: _model,
        systemPrompt: 'Tu es un assistant utile et concis.',
        history: history,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            text: reply,
            isUser: false,
          ),
        );
      });
    } on ProviderException catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            text: e.message,
            isUser: false,
            isError: true,
          ),
        );
      });
    } finally {
      if (mounted) setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openSettings() async {
    // Navigator.pushNamed() : on empile l'écran de paramètres au-dessus du chat.
    await Navigator.of(context).pushNamed('/settings');
    // Recharger le fournisseur / la clé / le modèle au retour, au cas où
    // l'utilisateur en aurait changé.
    await _loadProviderConfig();
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ChatBot GPT',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            Text(
              _provider.displayName,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Paramètres',
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const TypingIndicator();
                }
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Écrivez votre message…',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _sendMessage,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C63FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
