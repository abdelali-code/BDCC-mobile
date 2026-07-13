# Introduction Flutter — App de démo

Projet Flutter (Dart) qui reprend les exemples "fil rouge" du support de
cours *Introduction à Flutter — Partie 1* :

- **`main.dart`** — écran d'accueil avec un **Drawer** (menu latéral) qui
  navigue vers Quiz ou Weather (`Navigator.push` + `MaterialPageRoute`).
- **`quiz.dart`** — un **StatefulWidget** : une question à la fois, le score
  s'incrémente avec `setState()`, puis affichage du score final en %.
- **`weather_form.dart`** — un `TextField` (`onChanged` / `onSubmitted`) pour
  saisir une ville.
- **`weather.dart`** — appel d'une API REST avec le package `http` dans
  `initState()`, puis affichage dans une `ListView.builder`.

Le **Gallery**, **Camera** et **QRCode** présents plus loin dans le support
utilisent des packages Flutter 1.x aujourd'hui obsolètes/retirés
(`firebase_ml_vision`, `barcode_scan`, ancienne API `ImagePicker.pickImage`)
qui ne fonctionneraient plus tels quels sur une installation Flutter récente
— je ne les ai donc pas repris ici. Dis-moi si tu veux que je les
réimplémente avec leurs équivalents modernes (`image_picker` v1,
`google_mlkit_text_recognition`, `mobile_scanner`...).

---

## Comme tu n'as jamais utilisé Flutter : guide de A à Z

### 1. Installer le SDK Flutter

- Va sur **https://docs.flutter.dev/get-started/install** et choisis ton OS
  (Windows / macOS / Linux). Le site détecte le tien automatiquement.
- Le plus simple : télécharge **Android Studio** d'abord
  (https://developer.android.com/studio) — il installera Java/le SDK Android
  dont Flutter a besoin — puis, dans Android Studio, va dans
  **Plugins → recherche "Flutter" → Install** (ça installera aussi le plugin
  Dart). Android Studio proposera ensuite de télécharger le SDK Flutter à ta
  place si tu crées un nouveau projet Flutter.
- Sinon, méthode manuelle : télécharge le SDK Flutter (zip), décompresse-le,
  puis ajoute le dossier `flutter/bin` à ta variable d'environnement `PATH`.

### 2. Vérifier l'installation

Ouvre un terminal et tape :

```bash
flutter doctor
```

Cette commande (déjà montrée dans le support de cours) te dit exactement ce
qui manque (Android SDK, licences non acceptées, Chrome pour le web, etc.)
avec des ✓ / ✗ pour chaque composant. Suis simplement ses instructions
jusqu'à ce que tout soit vert. Les licences Android s'acceptent avec :

```bash
flutter doctor --android-licenses
```

### 3. Récupérer ce projet, générer les dossiers de plateforme, installer les dépendances

⚠️ **Étape importante** : je n'ai pas pu exécuter le SDK Flutter pour créer
ce projet (il n'est pas disponible dans mon environnement), donc je t'ai
fourni uniquement le code Dart (`lib/`, `pubspec.yaml`). Il manque les
dossiers `android/`, `ios/`, `web/`... que la commande `flutter create`
génère normalement. Une seule commande suffit pour les ajouter :

```bash
cd intro_flutter_app
flutter create .
flutter pub get
```

`flutter create .` détecte le projet existant (via `pubspec.yaml`) et
ajoute uniquement les dossiers de plateforme manquants — il ne touche pas
à `lib/main.dart` ni à `pubspec.yaml`. `flutter pub get` télécharge ensuite
les packages listés dans `pubspec.yaml` (`http` et `intl` ici) — l'équivalent
de `npm install`.

`flutter pub get` télécharge les packages listés dans `pubspec.yaml`
(`http` et `intl` ici) — c'est l'équivalent de `npm install`.

### 4. Lancer l'application — le plus simple pour débuter : le Web

Comme tu débutes, **inutile d'installer un émulateur Android** pour un
premier essai. Flutter peut lancer l'app directement dans Chrome :

```bash
flutter run -d chrome
```

Ça compile l'app et l'ouvre dans un onglet Chrome. C'est la façon la plus
rapide de voir le résultat sans rien configurer de plus.

### 5. Lancer sur un émulateur Android (comme dans le support de cours)

1. Dans Android Studio : **More Actions → Virtual Device Manager → Create
   Device**, choisis un téléphone (ex. Pixel 6) et une image système, puis
   lance l'émulateur (▶).
2. Vérifie qu'il est bien détecté :
   ```bash
   flutter devices
   ```
3. Lance l'app dessus :
   ```bash
   flutter run
   ```
   (si plusieurs appareils sont connectés, Flutter te demandera lequel
   choisir, ou utilise `flutter run -d <device_id>`).

### 6. Le Hot Reload — le super-pouvoir de Flutter

Une fois `flutter run` lancé, le terminal reste actif : modifie un fichier
`.dart`, sauvegarde, puis dans le terminal tape **`r`** → l'app se met à jour
**instantanément** sans perdre son état (ex: tu restes sur la même question
du quiz). Tape **`R`** pour un redémarrage complet, et **`q`** pour quitter.

### 7. Alternative : VS Code

Si tu préfères VS Code à Android Studio : installe l'extension **Flutter**
(qui installe aussi Dart), ouvre le dossier `intro_flutter_app`, puis
utilise **Run → Start Debugging (F5)**, ou le bouton "Run" en bas à droite
pour choisir l'appareil (Chrome, émulateur, etc.).

---

## Structure du projet

```
intro_flutter_app/
├── pubspec.yaml        # dépendances (http, intl) — équivalent package.json
├── lib/
│   ├── main.dart        # écran d'accueil + Drawer
│   ├── quiz.dart         # Quiz (StatefulWidget + setState)
│   ├── weather_form.dart # formulaire de saisie de ville
│   └── weather.dart      # appel API + ListView.builder
```

## Notes

- L'API météo utilise la clé et l'endpoint "samples" d'OpenWeatherMap
  fournis dans le support de cours — elle renvoie des **données d'exemple
  fixes**, pas la météo réelle. Pour de vraies prévisions, crée ta propre
  clé gratuite sur https://openweathermap.org/appid et remplace `_apiKey` +
  l'URL (`api.openweathermap.org` au lieu de `samples.openweathermap.org`)
  dans `weather.dart`.
- J'ai remplacé les images d'icônes météo (`clear.png`, `clouds.png`...)
  citées dans le PDF par des `Icons` Material intégrés, pour éviter d'avoir
  à fournir des fichiers d'assets externes.
