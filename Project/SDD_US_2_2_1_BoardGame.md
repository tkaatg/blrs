# SDD US 2.2.1 : Board Game - Route & Niveaux

- **User Story :** "En tant qu'enfant, je veux voir une route sinueuse avec des niveaux numérotés pour comprendre ma progression."
- **Statut :** En attente de validation
- **Référence Design :** Ergo Design System 1.0

---

## 1. Conception Visuelle (Ergo-Focus)
Conformément aux recommandations du Directeur UX :
- **La Route :** Un tracé sinueux (S-shape) qui guide l'œil du bas vers le haut. Couleur gris bitume avec des lignes pointillées blanches au centre.
- **Le Décor :** Fond vert "Herbe" avec des éléments décoratifs simples (arbres, fleurs cartoon) pour éviter le vide.
- **Les Bornes (Niveaux 1 à 10) :** 
    - Cercles larges (100px) avec bordure blanche épaisse.
    - Numérotés de 1 à 10.
    - États visuels :
        - **Locked (Gris) :** Icône de cadenas si le niveau n'est pas accessible.
        - **Score Rouge (0-2) :** Fond rouge, 1 étoile affichée.
        - **Score Jaune (3-4) :** Fond jaune, 2 étoiles affichées.
        - **Score Vert (5/5) :** Fond vert, 3 étoiles affichées.
        - **Actuel (Halo) :** Animation de pulsation sur le niveau à jouer.

---

## 2. Architecture Technique

### 2.1 Composants Flutter
- `BoardGameScreen` : Scaffold principal avec fond décoratif.
- `RoadPainter` : Un `CustomPainter` utilisant un `Path` de Bézier pour dessiner la route sinueuse de manière fluide.
- `LevelNode` : Widget personnalisé pour chaque borne de niveau. Il prend en paramètre un `LevelStatus` (modèle à créer).

### 2.2 Calcul des Positions
Pour que la route et les bornes soient alignées, nous utiliserons un algorithme de positionnement sinusoïdal :
- `X = Center + amplitude * sin(y / frequency)`
- Chaque borne $i$ sera placée à une hauteur relative $Y_i$ sur ce chemin.

---

## 3. Modèle de Données (Extension)

### `LevelStatus` (Local UI Model)
```dart
enum LevelState { locked, available, completed }

class LevelStatus {
  final int id;
  final LevelState state;
  final int score; // 0 to 5
  final bool isCurrent;
}
```

---

## 4. Interactions
- **Tap sur une borne disponible :** Lance l'animation de transition vers le quiz du niveau.
- **Tap sur une borne verrouillée :** Affiche une popup "Kid-Friendly" demandant si l'enfant veut débloquer le niveau (500 étoiles).
- **Parallax :** Léger effet de parallaxe sur les nuages/arbres lors du défilement pour l'engagement visuel.

---

## 5. Plan de Test (TDD)
- [ ] Vérifier que le défilement vertical fonctionne de 1 à 10.
- [ ] Tester que les bornes changent de couleur en fonction du score injecté (Mock data).
- [ ] Vérifier que les zones tactiles des bornes respectent le standard (80x80+).

---
*Document rédigé par l'Architecte avec la validation de la Direction Design.*
