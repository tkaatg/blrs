# SDD US 5.2 : Paramètres & Profil Joueur

- **User Story :** "En tant qu'utilisateur, je veux personnaliser mon profil et gérer mes préférences techniques (son, langue) via un menu centralisé et accessible."
- **Statut :** À implémenter
- **Référence Design :** Ergo Design System & Capture "Paramètres" (Feb 2026)

---

## 1. Architecture de Navigation & Accès

### 1.1 Raccourci Profil
- **Comportement :** Un clic sur le "Top Chip" affichant le Pseudo (en haut à gauche de l'écran) doit rediriger l'utilisateur directement vers l'onglet **Paramètres** (index 4).
- **Feedback :** Transition fluide immédiate via le `MainNavigationScreen`.

---

## 2. Contenu de l'écran Paramètres

### 2.1 Gestion du Profil (Section Haute)
- **Pseudo :**
  - **Format :** Strictement 5 lettres suivies de 4 chiffres (ex: TOOTO1234).
  - **Édition :** Un champ de saisie avec validation en temps réel.
- **Avatar (Mascottes Panneaux) :**
  - Widget de sélection horizontale ou grille.
  - **4 Choix :** Rond (Interdiction), Triangle (Danger), Losange (Priorité), Carré (Indication).
  - **Visuel :** Mascottes "animées" (yeux, bras) inspirées des assets cartoon.

### 2.2 Préférences Techniques (Cards Blanches)
Design inspiré de la capture jointe (Coins arrondis, ombre portée, icônes colorées) :
1. **Langue :** Toggle ou Sélecteur entre **Français (🇫🇷)** et **English (🇺🇸)**.
   - *Note technique :* Requiert une structure de traduction (i18n) pour tous les libellés de l'app.
2. **Son (SFX) :** Switch on/off. Gère les effets sonores (clics, succès, échecs).
3. **Musique :** Switch on/off. Gère la musique de fond d'ambiance.

### 2.3 Gestion & Support (Section Basse)
- **Confidentialité :** Bouton discret ouvrant un sous-menu :
  - **Configurer :** Lien vers les options de cookies/données.
  - **Supprimer mon compte :** Action critique avec demande de confirmation.
- **Support / FAQ :** Bouton style "Service Client" avec icône bulle de dialogue. Redirige vers une vue FAQ interne ou une URL externe.

---

## 3. Spécifications Techniques

### 3.1 Validation du Pseudo (Regex)
```regex
^[A-Z]{5}[0-9]{4}$
```

### 3.2 Modèle de Données (Extension `Player`)
```dart
class Player {
  // ... champs existants
  String avatarId; // circle, triangle, diamond, square
  bool musicEnabled;
  bool sfxEnabled;
  String languageCode; // 'fr' or 'en'
}
```

---
*Document rédigé par l'Architecte Technique.*
