# AGENTS.md — Baby Learning Road Signs (BLRS)

Ce fichier guide les agents IA (Antigravity, Copilot, etc.) intervenant sur ce projet.
Il DOIT être lu en premier avant toute modification de code.

---

## 🗂️ Structure du Projet

```
BLRS/
├── lib/
│   ├── main.dart                  # Point d'entrée, AuthWrapper, SplashScreen
│   ├── config/                    # AppConfig (env: dev/prod)
│   ├── models/                    # Player, LevelModel, Question
│   ├── services/                  # AuthService, SignService, LeaderboardService
│   ├── screens/                   # Écrans principaux (SANS Scaffold imbriqué !)
│   │   ├── main_navigation_screen.dart  # ⚠️ Seul Scaffold racine
│   │   ├── board_game_screen.dart
│   │   ├── quiz_screen.dart
│   │   ├── shop_screen.dart
│   │   ├── leaderboard_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/                   # Composants réutilisables
├── assets/
│   └── images/                    # avatars/, board_background.png
└── Project/                       # Documentation (PRD, SDD, Governance)
```

---

## ⚠️ RÈGLES CRITIQUES DE LAYOUT

### Règle #1 : UN SEUL Scaffold dans MainNavigationScreen
Le `MainNavigationScreen` est le **seul et unique Scaffold** de l'application.
- **NE JAMAIS** envelopper un écran fils dans un `Scaffold`.
- Les écrans dans `_getScreens()` retournent directement leur contenu (`Column`, `Stack`, `LayoutBuilder`, etc.).
- Un Scaffold imbriqué perturbe le `bottomNavigationBar` du parent et cause des erreurs RenderFlex.

### Règle #2 : Architecture du MainNavigationScreen
```
Scaffold (seul)
├── body: Center > ConstrainedBox(600px) > SizedBox > Stack
│   ├── Positioned.fill → IndexedStack (écrans)
│   ├── Positioned.fill → QuizScreen (overlay quiz si actif)
│   └── Positioned(top:0) → TopResourceBar
└── bottomNavigationBar: Container > SafeArea > Center > ConstrainedBox(600px) > BottomNav
```

### Règle #3 : Contrainte de largeur 600px
L'app est conçue pour mobile portrait. Sur desktop/tablette, le contenu est centré et limité à **600px** de large (côté body ET bottomNavigationBar). Ne pas supprimer cette contrainte.

### Règle #4 : SafeArea
La `SafeArea` est gérée par le Scaffold parent uniquement :
- `TopBar` : `SafeArea(bottom: false)` + `Positioned(top:0)`
- `BottomNav` : `SafeArea` appliquée dans le `bottomNavigationBar` du Scaffold

---

## 🎨 Design System

Palette principale (voir `Project/Ergo_Design_System.md`) :
- Fond foncé : `Color(0xFF00382B)` (vert forêt foncé)
- Fond moyen : `Color(0xFF00695C)` (teal)
- Accent : `Colors.amber` (étoiles), `Colors.redAccent` (quiz)
- Texte : `Colors.white`, `Colors.white60`, `Colors.white70`

Typographie : Bubbly/Glossy. Titres via `BubblyTitle` widget.

---

## 🧑‍💻 Stack Technique

| Domaine | Technologie |
|---|---|
| Framework | Flutter (Dart) |
| State Management | `provider` (StatefulWidget + setState pour local) |
| Backend | Firebase (Auth anonyme + Firestore) |
| CI/CD | Manual + Antigravity |

---

## 📋 Avant de Modifier du Code

1. **Lire le SDD correspondant** dans `Project/` (ex: `SDD_GlobalNavigation.md`)
2. **Ne jamais casser la règle du Scaffold unique**
3. **Tester avec** `flutter run -d chrome` après chaque modification
4. **Vérifier les logs** pour des erreurs RenderFlex ou exceptions de layout
5. **Respecter la limite 600px** pour les contraintes responsive

---

## 🚀 Commandes Utiles

```bash
# Lancer en mode développement
flutter run -d chrome

# Vérifier les erreurs de compilation
flutter analyze

# Tests unitaires
flutter test
```
