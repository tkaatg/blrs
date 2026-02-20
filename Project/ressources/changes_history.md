# Historique des Modifications - BLRS

---

## 20/02/2026 — Recette UI Quiz & Fix Navigation (commit en cours)

### BUG-002 : Overflow barre de navigation sur petits écrans
- **Fichier :** `lib/screens/main_navigation_screen.dart`
- **Problème :** `SizedBox(width: 75)` fixe dans `_buildNavItem` causait un `RenderFlex overflowed` sur les écrans < 375px.
- **Correction :** Remplacement par `Expanded` → les onglets partagent l'espace équitablement.

### UI-001 : Refonte UX Écran Quiz
- **Fichier :** `lib/screens/quiz_screen.dart`, `lib/widgets/bubbly_button.dart`

#### Décompte d'intro
- Centré dans la zone ciel (`Align(topCenter)` + `padding top: 90px`).
- Coloré par chiffre : 3 = orange, 2 = ambre, 1 = rouge.
- Effet pulse+scale animé (600ms, reverse) avec ombre colorée forte.
- Taille 140px.

#### Zone panneau
- Forme octogonale via `OctagonSignPainter` (CustomPainter, fond blanc, contour pointillé gris calculé sur le périmètre).
- Contenu centré, remontée via `bottom: 30` sur le `Positioned` et `top space: 60px`.
- Top space réduit de 100px → 60px pour remonter le panneau.

#### Animation casino
- Démarre 400ms après l'apparition du panneau (plus de délai de 2s).
- Vitesse : **12 FPS** (83ms/frame).
- Séquence d'arrêt raccourcie : forme 1 à **1s**, forme 2 à **1.5s**, forme 3 + début quiz à **2s**.

#### Route animée
- Utilise `assets/images/fond-anime.gif` (GIF nativement animé par Flutter).
- `key: ValueKey(_currentQuestionIndex)` pour forcer la recréation du widget à chaque question *(bug GIF web persistant, suivi BUG-003)*.

#### Label question
- Toujours visible (suppression de la condition `if introStep != countdown`).
- Nouveau wording : **"Quiz X - Question Y/Z : Trouver le bon panneau !"**
- Style : 16px, blanc, FontWeight.w900, ombre légère.

#### Zone messages feedback
- `SizedBox(height: 46)` **toujours présent** dans le layout.
- Affiche "🎉 Gagné !" / "❌ Perdu..." / "⏱ Temps terminé !" en 22px bold.
- `SizedBox(height: 6)` d'espacement entre la zone message et la row timer/bouton.
- Élimine les décalages de layout à l'apparition/disparition des messages.

#### Bouton Indice
- `BubblyButton.onTap` rendu nullable (`VoidCallback?`).
- Désactivé (grisé, `Colors.grey.shade600`) pendant l'animation d'intro.

#### Wide screen
- Contenu limité à **600px de large**, centré.

---

## 19/02/2026 — Restauration Layout + Corrections Recette initiale

- Restauration `main_navigation_screen.dart` et `board_game_screen.dart` au commit `ee3422d` (fix barre nav au milieu de l'écran).
- Premier passage de corrections quiz : zone panneau, casino 3fps, feedback messages, question dans la zone basse.

---

## 18/02/2026 — Corrections Recette #1

- Fix bandes jaunes sur wide screen → fond `Color(0xFF00382B)`.
- Harmonisation titres avec `BubblyTitle` (fs 32 fixe).
- Correction écran Réglages (contenu visible).
- Popin lancement : remplacement étoile → texte "Prêt pour jouer ?".
- Cinématique quiz v1 : décompte, contour pointillé, casino, séquence d'arrêt.

---

## 14/02/2026 — Implémentation initiale Quiz

- `QuizScreen` : états, timer 15s, sélection options, feedback.
- `SignService` : chargement CSV + fallback 10 questions garanties.
- `QuizTimer` : LinearProgressIndicator animé.
- Résultats quiz : bilan étoiles, dots/check, bouton retour.

---

## Problèmes Connus (Open)

| ID | Description | Priorité |
|---|---|---|
| BUG-003 | GIF fond-anime.gif ne redémarre pas sur Chrome Web entre questions (ValueKey non concluant) | Basse |
