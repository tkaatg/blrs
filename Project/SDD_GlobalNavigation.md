# SDD - Navigation Globale & Architecture UI

- **User Story :** "En tant qu'enfant, je veux une navigation simple et cohérente pour passer d'un écran à l'autre sans me perdre."
- **Statut :** Implémenté / En cours d'affinage
- **Référence Design :** Ergo Design System (Section 6 & 7)

---

## 1. Architecture de Navigation

L'application utilise un système de navigation centralisé géré par `MainNavigationScreen`.

### 1.1 Structure Technique
- **Conteneur :** `IndexedStack` (Flutter) pour maintenir l'état de chaque onglet (Boutique, Accueil, Classement, Réglages) sans rechargement.
- **Scaffold Principal :** Gère l'affichage dynamique de la Barre de Ressources (Top) et de la Barre de Navigation (Bottom).
- **Overlay Quiz :** Le `QuizScreen` s'affiche par-dessus l'onglet actif via une condition de rendu, évitant les transitions de page complexes (voir [SDD US 2.3.2](./SDD_US_2_3_2_QuizMechanics.md)).

---

## 2. Écrans & Onglets (Bottom Navigation)

La barre de navigation basse est conçue selon les principes de **Hit Zones XXL** de l'@[Ergo_Design_System.md].

| Onglet | Icône | Description | Statut |
| :--- | :--- | :--- | :--- |
| **Boutique** | `shopping_cart` | Achat d'étoiles et retrait de publicités. | Implémenté |
| **Accueil** | `home` | Plateau de jeu principal (Board Game). | Implémenté |
| **Jouer** | `play_circle` | Lancement rapide du dernier niveau disponible. | Implémenté |
| **Classement** | `leaderboard` | Leaderboard mondial et amis. | En développement |
| **Réglages** | `settings` | Préférences techniques et profil. | En cours (US 5.2) |

### 2.1 Ergonomie des Onglets
- **Standardisation :** Toutes les zones tactiles font **75px** de large ([Ergo Design Section 1.2]).
- **Simplification :** Utilisation d'un rayon de courbure de **12px** pour les encadrés de sélection (plus moderne).
- **Feedback visuel :** Changement de couleur de l'icône et apparition du libellé pour l'onglet sélectionné.

---

## 3. Barre de Ressources (Top Bar)

Fixe et persistante, elle affiche les indicateurs vitaux du joueur.

- **Bloc Profil (Gauche) :** Affiche l'avatar et le pseudo.
    - **UX :** Un clic redirige directement vers l'onglet **Réglages**.
    - **UI :** Police grasse 16pt pour une lisibilité maximale.
- **Bloc Étoiles (Droite) :** Affiche le solde actuel.
    - **UX :** Le bouton **(+)** redirige vers l'onglet **Boutique**.
- **Style :** Conforme au style **Bubbly/Glossy** ([Ergo Design Section 6.3]), utilise des dégradés teal profonds avec bordures blanches semi-transparentes.

---

## 4. Expérience de Jeu (Board Game)

L'écran Accueil (Board Game) est le cœur de l'expérience :
- **Portrait Only :** Fixé pour éviter la désorientation de l'enfant.
- **Scaling Adaptatif :** Largeur limitée à **600px** sur tablette pour préserver l'ergonomie.
- **Navigation Linéaire :** L'enfant suit la route et appuie sur les pions de niveau.

---
*Document récapitulatif de l'architecture de navigation globale.*
