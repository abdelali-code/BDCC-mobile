# Event Challenge — TP Gestion des Événements Android

Projet Android Studio (Kotlin) implémentant l'**Activité n°1** du support de cours
*"Développement Mobile Natif Android"* : plusieurs interfaces graphiques qui gèrent
chacune un évènement différent, avec navigation entre écrans par **Swipe**
(gauche = écran suivant, droite = écran précédent).

## Écrans / évènements couverts

| Écran | Fichier | Évènement(s) démontré(s) |
|---|---|---|
| 1 | `MainActivity` | `Click` + `LongClick` |
| 2 | `MainActivity2` | `Swipe` (gauche / droite) |
| 3 | `MainActivity3` | `TextChange` (`addTextChangedListener`) |
| 4 | `MainActivity4` | `OnItemSelected` (Spinner) |
| 5 | `MainActivity5` | `OnTouch` (ACTION_DOWN / MOVE / UP) |
| 6 | `MainActivity6` | `CreateContextMenu` + `OnDateSet` (DatePickerDialog) |

La classe utilitaire `OnSwipeTouchListener.kt` (basée sur `GestureDetector`) est
réutilisée par chaque activité pour détecter les glissements gauche/droite et
naviguer via `Intent` + `startActivity`, exactement comme demandé dans l'énoncé
("La navigation entre les activités sera effectuée en utilisant les évènements
Swipe gauche et droite").


## Structure

```
EventChallenge/
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/ma/android/eventchallenge/
│       │   ├── OnSwipeTouchListener.kt
│       │   ├── MainActivity.kt   (Click / LongClick)
│       │   ├── MainActivity2.kt  (Swipe)
│       │   ├── MainActivity3.kt  (TextChange)
│       │   ├── MainActivity4.kt  (OnItemSelected)
│       │   ├── MainActivity5.kt  (OnTouch)
│       │   └── MainActivity6.kt  (CreateContextMenu / OnDateSet)
│       └── res/
│           ├── layout/activity_main*.xml
│           └── values/ (colors.xml, strings.xml, styles.xml)
├── build.gradle
├── settings.gradle
└── gradle.properties
```

## Notes pédagogiques

- Chaque activité reprend le motif vu en cours : `findViewById` pour lier le
  XML au Kotlin, puis `setOnClickListener` / `setOnLongClickListener` /
  `setOnTouchListener` selon le composant.
- `MainActivity6` illustre les deux évènements restants de l'énoncé :
  - `CreateContextMenu` via `registerForContextMenu()` +
    `onCreateContextMenu()` / `onContextItemSelected()`.
  - `OnDateSet` via `DatePickerDialog` dont le callback correspond à
    l'interface `OnDateSetListener`.
