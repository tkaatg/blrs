# SDD US 2.2.1 : Board Game - Route & Niveaux

- **User Story :** "En tant qu'enfant, je veux voir une route sinueuse avec des niveaux numérotés pour comprendre ma progression."
- **Statut :** En attente de validation
- **Référence Design :** Ergo Design System 1.0

---

## 1. Conception Visuelle (Premium Casual)
Conformément aux nouvelles orientations Design :
- **Le Fond :** Image premium haute résolution (`board_background.png`) répétée verticalement deux fois pour couvrir les 10 niveaux.
- **La Route :** Fait partie intégrante de l'image de fond (style terre battue/sable).
- **Le Décor :** Arbres, rivières et clôtures inclus dans l'asset graphique pour un rendu "fait main".
- **Les Bornes (Niveaux 1 à 10) :** 
    - Cercles larges (100px) avec bordure blanche épaisse.
    - Numérotés de 1 à 10.
    - Alignés manuellement sur les courbes de la route visuelle.

---

## 2. Architecture Technique & Responsivité

### 2.1 Composants Flutter
- `BoardGameScreen` : Scaffold principal. Utilise `LayoutBuilder` pour adapter la largeur.
- **Responsive Wrap :** Le plateau est centré et limité à **600px de large** maximum pour assurer la cohérence sur tablette.
- **Background Junction :** Utilisation d'un dégradé de transition (`LinearGradient`) pour masquer la couture entre les deux images répétées.

### 2.2 Positionnement Dynamique
- `RoadPathBuilder` : Fournit un `Path` invisible calculé pour suivre les virages de l'image de fond. Utilisé pour l'animation de la voiture.
- **Scaling Factor :** Les positions des niveaux sont relatives à la largeur du plateau (boardWidth) pour rester alignées lors du redimensionnement.

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
