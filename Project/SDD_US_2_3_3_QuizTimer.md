# SDD US 2.3.3 : Timer de 15 secondes par question

- **User Story :** "En tant qu'enfant, je veux avoir un temps limité pour répondre afin de rendre le jeu plus dynamique, mais sans que ce soit trop stressant."
- **Statut :** Implémenté (Retro-engineering)
- **Référence Design :** Ergo Design System 1.0

---

## 1. Description du comportement

Le chronomètre est l'élément qui apporte le défi ludique au quiz :

1. **Durée :** 15 secondes par question.
2. **Affichage :** 
   - Un compteur numérique (MM:SS) à gauche du panneau de contrôle inférieur.
   - Le texte devient rouge quand le temps est presque écoulé (en option).
3. **Comportement à l'épuisement (Time-out) :**
   - La question s'arrête.
   - Le feedback affiche "Temps écoulé !".
   - La réponse correcte est révélée (bordure verte).
   - Aucun point n'est marqué pour cette question.
4. **Récompense de rapidité :** Le score gagné est proportionnel au temps restant (`temps_restant * 10`).

---

## 2. Implémentation Technique

### 2.1 Gestion du temps (`QuizScreen`)
Le Timer utilise un `Timer.periodic` de la bibliothèque standard `dart:async` couplé à un `AnimationController` pour la synchronisation visuelle éventuelle.

```dart
void _startTimer() {
  _secondsRemaining = 15;
  _countdownTimer?.cancel();
  _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_secondsRemaining > 0) {
      setState(() => _secondsRemaining--);
    } else {
      _handleTimeout();
    }
  });
}
```

### 2.2 Calcul du score
```dart
int starsGained = _secondsRemaining * 10;
```

---
*Document rédigé via Retro-engineering de l'implémentation actuelle.*
