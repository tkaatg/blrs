# SDD US 2.2.2 : Statut des niveaux (Rouge/Jaune/Vert)

- **User Story :** "En tant qu'enfant, je veux voir d'un coup d'œil ma réussite sur chaque niveau grâce à des couleurs simples (Rouge, Jaune, Vert)."
- **Statut :** Implémenté (Retro-engineering)
- **Référence Design :** Ergo Design System 1.0

---

## 1. Description du comportement
Chaque "borne" (niveau) sur la carte change d'apparence en fonction de l'état de progression du joueur :

1. **Niveau Verrouillé (Locked) :**
   - Couleur : Gris (#BDBDBD).
   - Icône : Cadenas blanc au centre du cercle.
   - Interaction : Affiche une notification indiquant quel niveau débloquer.

2. **Niveau Disponible (Available) :**
   - Couleur : Rouge Orange (#F25022) - Couleur d'appel à l'action.
   - Contenu : Numéro du niveau en blanc.
   - Interaction : Ouvre la boîte de dialogue pour lancer le quiz (Coût 500 ⭐).

3. **Niveau Réussi (Completed) :**
   - La couleur dépend du score obtenu (basé sur 10 questions) :
     - **Vert (#7FBA00) :** Excellence (Score >= 8/10).
     - **Jaune (#FFB900) :** Réussite moyenne (Score 5/10 à 7/10).
     - **Rouge (#F25022) :** Échec relatif (Score < 5/10).
   - Affichage des étoiles : Un arc de 10 petites étoiles au-dessus du pion montre le score précis.

---

## 2. Implémentation Technique

### 2.1 Composant `LevelNode`
Le composant `LevelNode` calcule sa couleur de fond (`baseColor`) via une méthode `_getScoreColor()` :
```dart
Color _getScoreColor() {
  if (widget.level.score >= 8) return const Color(0xFF7FBA00); // Vert
  if (widget.level.score >= 5) return const Color(0xFFFFB900); // Jaune
  return const Color(0xFFF25022); // Rouge
}
```

### 2.2 États des étoiles
Les étoiles graphiques au-dessus du pion sont colorées en **Ambre** pour chaque point marqué, et en blanc semi-transparent pour les points manquants.

---
*Document rédigé via Retro-engineering de l'implémentation actuelle.*
