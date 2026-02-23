# Historique des Modifications - BLRS

## 23/02/2026 — EPIC 4 : Audio & Immersion + Polissage Final
 
### 🛠️ BUG-005 : Fix Scoring & Leaderboard
- **Problème :** Les scores etXP n'étaient validés qu'au clic sur "RETOUR", causant une perte de progression si l'utilisateur changeait d'onglet depuis le bilan.
- **Correction :** Persistance **immédiate** (Firestore via `AuthService.updatePlayer`) dès l'affichage du bilan.
- **Validation :** Le classement est mis à jour instantanément à la fin du quiz.

### 🎨 UI-007 : Unification du Naming "Paramètres"
- **Navigation :** Renommage de l'onglet "Réglages" en **"Paramètres"** pour cohérence avec le titre de l'écran.

### 🔊 EPIC 4 : Audio & Immersion (Finalisation)
- **Service Centralisé :** Création de `AudioService` (audioplayers 6.5) avec gestion séparée Musique/SFX.
- **Musique :** Transitions automatiques entre Carte (`map_theme.mp3`) et Quiz (`quiz_theme.mp3`).
- **SFX Quiz :** Sons pour décompte, bonne réponse, erreur, timeout et bilan (fanfare).
- **Feedback :** Vibrations haptiques sur les erreurs et le temps écoulé.
- **Réglages :** Coupure instantanée de la musique/sons dès modification dans les paramètres.

---

## 22/02/2026 — Recette Shop, Settings & Quiz Polish (commit b72dd70)

### BUG-003 : Crash RenderFlex (Expanded imbriqués)
- **Fichier :** `lib/screens/quiz_screen.dart`
- **Correction :** Suppression des `Expanded` en conflit avec `MainAxisSize.min`. Calcul dynamique des tailles via `LayoutBuilder`.

### UI-002 à UI-006 : Polish Quiz & Bilan
- **Bilan :** Affichage décomposé (Brut / Déduction indice / Net crédité).
- **GIF Route :** Rechargement forcé via `ValueKey(_gifSeed)` à chaque question.
- **Feedback :** Timer bloqué à `00:00` sur timeout et bordure orange clignotante sur la bonne réponse.
- **Ergo :** Gaps entre les cartes d'options augmentés à **20px**.
- **Dialog :** Simplification radicale du popin de lancement de niveau.

### US 5.1/5.2 : Settings, Leaderboard & Shop
- **Settings :** Validation pseudo assouplie (4-6 lettres + 4-6 chiffres), max 12 car.
- **Leaderboard :** Espacement augmenté entre les lignes (10px margin/16px padding). Suppression du halo blanc autour des avatars.
- **Shop :** Redesign complet du bloc "Sans Pub" (dégradé vert forêt, icône interdite "PUB" barrée, prix sur une ligne).

### ⚙️ Gouvernance & Sécurité
- **AGENTS.md :** Ajout des règles Windows/PowerShell, workflow SDD/Linear obligatoire, et interdiction d'exécution Git auto.
- **Sécurité :** Suppression des scripts Python contenant des secrets et mise à jour du `.gitignore`.

---

## 21/02/2026 — Préparation Recette (Commits 4b74337, 8b61ac6)

- Travaux préparatoires sur le bilan des étoiles et les validations de réglages.
- Restructuration du backlog (Epic 6).

---

## 20/02/2026 — Recette UI Quiz & Fix Navigation (commit d1da54a)

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
| - | (Aucun bug critique identifié sur cette session) | - |
