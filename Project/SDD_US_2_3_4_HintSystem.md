# SDD US 2.3.4 : Système d'indices (Star/Index)

- **User Story :** "En tant qu'enfant, je veux pouvoir échanger quelques-unes de mes étoiles contre un indice si je ne connais pas la réponse, pour ne pas rester bloqué."
- **Statut :** Implémenté (Retro-engineering)
- **Référence Design :** Ergo Design System 1.0

---

## 1. Description du comportement

Le système d'indices permet d'aider l'enfant tout en introduisant une gestion de ressources (les étoiles) :

1. **Coût :** L'utilisation d'un indice coûte **5 étoiles** au joueur.
2. **Mécanique :** 
   - Avant utilisation : Le bouton affiche "Indice -5 ⭐".
   - Après utilisation : Le bouton est remplacé par un label textuel révélant la famille du panneau (ex: "DANGER", "OBLIGATION").
3. **Pénalité de bilan :** À la fin du quiz, chaque indice utilisé est rappelé dans le tableau des scores avec une soustraction de -5 ⭐ sur le gain total.
4. **Visibilité :** Si le joueur est déjà en "Mode Gratuit" (replay d'un niveau déjà réussi à 10/10), les indices sont gratuits.

---

## 2. Implémentation Technique

### 2.1 Mapping des indices (`SignService`)
Le service analyse l'identifiant de la forme (`shapeId`) pour déterminer la catégorie simplifiée à afficher :
```dart
static String _getHintLabel(String shapeId) {
  if (shapeId.contains('danger')) return 'DANGER';
  if (shapeId.contains('interdiction')) return 'INTERDICTION';
  if (shapeId.contains('obligation')) return 'OBLIGATION';
  // ... mapping complet
}
```

### 2.2 UI `HintArea`
Le widget change dynamiquement d'état dans le `QuizScreen` :
```dart
if (_hintUsed)
  Text(': ${question.hintLabel}', style: ...)
else
  GestureDetector(
    onTap: _useHint,
    child: Row(...) // Bouton interactif
  )
```

---
*Document rédigé via Retro-engineering de l'implémentation actuelle.*
