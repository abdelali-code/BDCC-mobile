# ChatBot GPT — Application Flutter

Application ChatBot qui interagit avec l'API ChatGPT (OpenAI), réalisée pour le
projet final du module "Gestion des données et personnalisation de UI avec Flutter".

## Fonctionnalités (au-delà de la version minimaliste du blog)

| Exigence du projet      | Implémentation |
|--------------------------|----------------|
| **Design**               | Thème Material 3 personnalisé, dégradé violet, bulles de discussion avec coins arrondis asymétriques, ombres douces, écran de démarrage animé. |
| **Comportement**          | Indicateur de saisie animé (3 points), défilement automatique, gestion des erreurs API affichée comme message dans le chat, validation de formulaire. |
| **Navigation**            | `onGenerateRoute` centralisé dans `main.dart` + `Navigator.pushNamed`, `pushReplacementNamed`, `pop` (Splash → Login → Chat → Settings), exactement les méthodes vues en cours. |
| **Authentification**      | Écran de connexion (nom d'utilisateur + clé API), état persisté avec `SharedPreferences`, redirection automatique si déjà connecté, déconnexion avec confirmation. |
| **Animation**              | Fade + scale sur le splash screen, apparition en fondu des bulles de message, indicateur de saisie « pulsant », transition de sauvegarde des paramètres. |

## Structure du projet

```
lib/
├── main.dart                 # Point d'entrée + thème + routes nommées
├── models/
│   └── message.dart          # Modèle ChatMessage
├── services/
│   ├── auth_service.dart     # Authentification locale (SharedPreferences)
│   └── chat_service.dart     # Appel à l'API ChatGPT (OpenAI)
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── chat_screen.dart
│   └── settings_screen.dart
└── widgets/
    ├── chat_bubble.dart
    └── typing_indicator.dart
```

## Installation

1. Créez un projet Flutter (ou copiez ces fichiers dans un projet existant) :
   ```bash
   flutter create chatgpt_flutter_app
   ```
2. Remplacez le dossier `lib/` généré par celui fourni ici, et copiez `pubspec.yaml`.
3. Installez les dépendances :
   ```bash
   flutter pub get
   ```
4. Lancez l'application :
   ```bash
   flutter run
   ```
5. Au premier lancement, connectez-vous avec un nom d'utilisateur quelconque et
   collez votre **clé API OpenAI** (obtenue sur https://platform.openai.com/api-keys).
   Vous pouvez la modifier plus tard depuis l'icône ⚙️ dans le chat.

## Notes importantes

- La clé API est stockée **uniquement en local** sur l'appareil (SharedPreferences),
  jamais envoyée ailleurs qu'à l'API OpenAI elle-même.
- Le modèle utilisé par défaut est `gpt-3.5-turbo` (modifiable dans `ChatService`).
- Pour une vraie mise en production, il faudrait idéalement proxyfier les appels
  API via un backend afin de ne jamais exposer la clé côté client.

## Pistes d'amélioration supplémentaires

- Persister l'historique des messages avec `sqflite` (vu en cours) au lieu de le
  perdre à la fermeture de l'app.
- Gérer plusieurs conversations (liste de sessions).
- Ajouter le mode sombre.
- Utiliser `Provider`, `BLoC` ou `GetX` (vus en cours) pour la gestion d'état au
  lieu de `setState`, si l'application grandit.
