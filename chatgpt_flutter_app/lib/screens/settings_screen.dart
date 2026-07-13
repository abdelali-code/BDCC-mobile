import 'package:flutter/material.dart';
import '../providers/ai_provider.dart';
import '../providers/provider_registry.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  String? _selectedProviderId;
  final Map<String, TextEditingController> _keyControllers = {};
  final Map<String, String> _selectedModels = {};
  final Map<String, bool> _obscure = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    for (final p in aiProviders) {
      _keyControllers[p.id] = TextEditingController();
      _obscure[p.id] = true;
    }
    _load();
  }

  Future<void> _load() async {
    final selected = await _authService.getSelectedProviderId();
    final keys = await _authService.getApiKeys();
    for (final p in aiProviders) {
      _keyControllers[p.id]!.text = keys[p.id] ?? '';
      _selectedModels[p.id] = await _authService.getModel(p.id);
    }
    if (!mounted) return;
    setState(() {
      _selectedProviderId = selected;
      _loading = false;
    });
  }

  Future<void> _saveKeyOnly(AiProvider provider) async {
    await _authService.saveApiKey(provider.id, _keyControllers[provider.id]!.text.trim());
    await _authService.saveModel(provider.id, _selectedModels[provider.id]!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Clé enregistrée pour ${provider.displayName}.')),
    );
  }

  Future<void> _activateProvider(AiProvider provider) async {
    final key = _keyControllers[provider.id]!.text.trim();
    if (key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ajoutez une clé API pour ${provider.displayName}.')),
      );
      return;
    }
    await _authService.saveApiKey(provider.id, key);
    await _authService.saveModel(provider.id, _selectedModels[provider.id]!);
    await _authService.setSelectedProviderId(provider.id);
    if (!mounted) return;
    setState(() => _selectedProviderId = provider.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${provider.displayName} est maintenant actif.')),
    );
  }

  @override
  void dispose() {
    for (final c in _keyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fournisseurs IA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Navigator.pop() : on revient à l'écran précédent (le chat).
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Choisissez un fournisseur, renseignez sa clé API puis '
            'appuyez sur "Utiliser". Groq et Gemini proposent un palier '
            'gratuit, pratiques pour tester rapidement.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ...aiProviders.map(_buildProviderCard),
        ],
      ),
    );
  }

  Widget _buildProviderCard(AiProvider provider) {
    final isActive = provider.id == _selectedProviderId;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF6C63FF) : Colors.grey.shade200,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        provider.displayName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (provider.isFree) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Gratuit',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isActive)
                const Icon(Icons.check_circle, color: Color(0xFF6C63FF)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            provider.description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _keyControllers[provider.id],
            obscureText: _obscure[provider.id] ?? true,
            decoration: InputDecoration(
              labelText: 'Clé API',
              isDense: true,
              prefixIcon: const Icon(Icons.vpn_key_outlined, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  (_obscure[provider.id] ?? true)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                ),
                onPressed: () => setState(
                  () => _obscure[provider.id] = !(_obscure[provider.id] ?? true),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedModels[provider.id],
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Modèle', isDense: true),
            items: provider.suggestedModels
                .map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedModels[provider.id] = value);
              }
            },
          ),
          const SizedBox(height: 8),
          SelectableText(
            'Obtenir une clé : ${provider.apiKeyUrl}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6C63FF)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _saveKeyOnly(provider),
                  child: const Text('Enregistrer'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: isActive ? null : () => _activateProvider(provider),
                  child: Text(isActive ? 'Actif' : 'Utiliser'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
