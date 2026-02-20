# SDD US 2.3.2 : Mécanique du Quiz (Gameplay)

- **User Story :** "En tant qu'enfant, je veux répondre à un quiz simple pour valider le niveau et gagner des étoiles."
- **Statut :** Implémenté ✅ (recette 20/02/2026)
- **Référence Design :** Ergo Design System 1.0

---

## 1. Conception Visuelle & Expérience

### 1.1 Déroulement (Séquence "Juicy" par question)

1. **Transition :** La route défile en arrière-plan (GIF `fond-anime.gif`). Un gros décompte (3, 2, 1) s'affiche centré dans la zone ciel.
   - Décompte coloré par chiffre : 3 = orange, 2 = ambre, 1 = rouge.
   - Effet pulse + scale animé (600ms, reverse).
2. **Mise en place :** Les 3 zones de propositions sont blanches/vides. La zone panneau est octogonale avec un contour pointillé gris.
3. **Révélation Panneau :** Dès la fin du décompte, le contenu du panneau apparaît avec un effet "Pop" (elasticOut).
4. **Effet Casino (T+400ms) :** Les 3 zones font défiler les formes à **12 FPS** (83ms/frame) :
   - Forme 1 se fige à **T+1s**
   - Forme 2 se fige à **T+1.5s**
   - Forme 3 se fige à **T+2s** → Quiz démarre.
5. **Phase Question :**
   - Label toujours visible : `"Quiz [N] - Question [X]/10 : Trouver le bon panneau !"` (16px, blanc, bold)
   - Bouton Indice désactivé (grisé) pendant l'intro.
6. **Phase Réponse :**
   - 3 grandes cartes (formes géométriques).
   - Feedback immédiat : bordure épaisse **clignotante** (Vert ✅ / Rouge ❌).
7. **Phase Feedback :**
   - Zone message fixe (46px) : "🎉 Gagné !" / "❌ Perdu..." / "⏱ Temps terminé !" (22px bold, couleur thématique).
   - Espace réservé en permanence → **zéro décalage** de layout.
   - Bouton **"SUIVANT"** (bleu azur).
8. **Phase Résultat (Fin de Quiz) :**
   - Explosion de confettis, gain d'étoiles, bouton "RETOUR CARTE".

### 1.2 Interface Responsive (Premium UX)
- **Portrait Only.**
- **Layout Split :**
  - **Body :** Panneau octogonal (droite, 140px) + Route animée GIF.
  - **Bottom Panel :**
    - Label question (toujours visible, largeur totale).
    - 3 cartes de sélection.
    - Zone feedback fixe 46px.
    - Row : Minuteur numérique (gauche 1/3) + Bouton Indice/Suivant (droite 2/3).
  - **Tablette/Wide :** Contenu centré max **600px**.

---

## 2. Architecture Technique

### 2.1 États du Quiz
```dart
enum QuizState { intro, questioning, feedback, results }
enum IntroStep  { countdown, showSign, casinoRolling, none }
```

### 2.2 Séquence temporelle (par question)
| Étape | Timing | Description |
|---|---|---|
| Décompte 3→1 | 0–3s | Timer.periodic 1s, couleur par chiffre |
| Apparition panneau | T+0ms | IntroStep.showSign, TweenAnimationBuilder elasticOut |
| Lancement casino | T+400ms | Timer.periodic 83ms (12 FPS) |
| Forme 1 figée | T+1000ms | _rolling1 = false |
| Forme 2 figée | T+1500ms | _rolling2 = false |
| Forme 3 figée + Quiz | T+2000ms | IntroStep.none, QuizState.questioning |

### 2.3 Composants clés
- `OctagonSignPainter` : CustomPainter octogonal, fond blanc, contour pointillé gris calculé sur le périmètre de l'octogone.
- `AnimatedBlinkingBorder` : Bordure clignotante (300ms, repeat/reverse) pour le feedback sélection.
- `BubblyButton` : `onTap` nullable pour état désactivé (indice pendant intro).

### 2.4 Garantie de Fiabilité (Anti-Softlock)
- **Injection Directe :** La réponse correcte est systématiquement ajoutée avant les distracteurs.
- **Normalisation :** `.toLowerCase()` sur tous les IDs de formes.
- **Fallback :** Si < 3 options, complétion avec formes aléatoires.

---

## 3. Problèmes Connus / En Cours

| ID | Description | Statut |
|---|---|---|
| BUG-003 | Redémarrage du GIF fond-anime.gif à chaque nouvelle question (ValueKey testé, non concluant sur Web) | 🔴 En attente |

---

## 4. Historique des Modifications

| Date | Modification |
|---|---|
| 14/02/2026 | Implémentation initiale du quiz (états, timer, casino, casino). |
| 18/02/2026 | Corrections recette : popin, barre nav, titres harmonisés. |
| 19/02/2026 | Corrections recette : restauration layout nav, fix overflow nav bar. |
| 20/02/2026 | Refonte UX quiz : décompte coloré centré ciel, zone octogonale, casino 12fps (2s total), label permanent, zone feedback 46px fixe, route GIF, wording "Trouver le bon panneau !". |

---
*Document rédigé et maintenu par l'Architecte Technique.*
