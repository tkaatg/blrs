# SDD US 2.2.3 : Déblocage de niveau par réussite

- **User Story :** "En tant qu'enfant, je veux que le niveau suivant se débloque automatiquement dès que j'ai réussi le niveau actuel avec au moins la moitié de bonnes réponses (5/10)."
- **Statut :** Implémenté (Seuil mis à jour à 5/10)
- **Référence Design :** Ergo Design System 1.0

---

## 1. Description du comportement

Le système de progression est séquentiel et basé sur la performance :

1. **Condition de succès :** Le joueur doit obtenir un score d'au moins **5/10** au quiz pour "passer" le niveau.
2. **Action post-quiz :**
   - Si score >= 5 : Le niveau suivant est ajouté à la liste `unlockedLevels` du joueur.
   - La propriété `maxLevelUnlocked` est incrémentée si le joueur vient de réussir son niveau le plus haut atteint.
3. **Persistance :** Le score est sauvegardé uniquement s'il est meilleur que le score précédent pour ce niveau.
4. **Retour Carte :** L'application redirige automatiquement l'utilisateur vers la vue Accueil pour voir sa progression.

---

## 2. Implémentation Technique

### 2.1 Logique de déblocage (`MainNavigationScreen`)
La méthode `_onQuizComplete` centralise la logique de progression :

```dart
// Débloque le niveau suivant si le score est >= 5
if (score >= 5) {
  int nextLevel = levelId + 1;
  if (nextLevel <= 10) {
    if (!widget.player.unlockedLevels.contains(nextLevel)) {
      widget.player.unlockedLevels.add(nextLevel);
    }
    if (levelId == widget.player.maxLevelUnlocked) {
      widget.player.maxLevelUnlocked = nextLevel;
    }
  }
}
```

---
*Document rédigé suite à la mise à jour du seuil de déblocage.*
