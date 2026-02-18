# SDD EPIC 3 : Gamification & Leaderboard

Ce document détaille l'implémentation technique du système de scoring et du classement mondial (Leaderboard) pour BLRS.

## 1. Modèle de Données (Scoring)

Le système de points a été affiné pour séparer la progression visuelle de la performance compétitive.

### Player Model (`player_model.dart`)
- `statsLevels` (Map<String, int>) : Stocke le record de **bonnes réponses** (0-10) par niveau. Utilisé pour l'affichage des étoiles (Rouge/Jaune/Vert) sur la carte.
- `bestPointsByLevel` (Map<String, int>) : Stocke le record de **points de rapidité** par niveau.
- `points` (int) : Score total global, recalculé comme la somme des valeurs de `bestPointsByLevel`. C'est ce score qui est utilisé pour le classement.

## 2. Logique de Fin de Quiz

Dans `MainNavigationScreen._onQuizComplete` :
1. Mise à jour de `statsLevels` si le nombre de bonnes réponses est supérieur au record précédent.
2. Si le quiz n'est pas en mode "Gratuit" (rejouer un niveau déjà complété à 10/10) :
   - Comparaison des points gagnés avec `bestPointsByLevel`.
   - Si record battu, mise à jour et appel à `updatePointsFromBestScores()`.

## 3. Leaderboard Service (`leaderboard_service.dart`)

### Génération de Bots (Seeding)
Pour simuler une communauté active au lancement, environ **5000 bots** sont générés dynamiquement selon une pyramide de distribution :
- Niveau 10 : 94 joueurs (7000 - 14000 pts)
- ...
- Niveau 1 : 1000 joueurs (5 - 1400 pts)
Les scores se terminent obligatoirement par **0 ou 5** pour rester cohérents avec les bonus de rapidité.

### Système d'Affichage "Smart View"
La vue retournée au joueur est adaptative pour favoriser l'engagement :
- **Top 10** : Si le joueur est classé entre 1 et 10, affichage simple de la liste.
- **Top 3 + Fenêtre Contextuelle** : Si le joueur est au-delà du rang 10 :
  - Affichage des rangs 1, 2 et 3 (Podium).
  - Séparateur visuel (`...`).
  - Affichage d'une fenêtre de 5 joueurs centrée sur le joueur actuel ( [Moi-2, Moi-1, MOI, Moi+1, Moi+2] ).

## 4. UI/UX (`leaderboard_screen.dart`)

- **Podium** : Médailles Or, Argent et Bronze pour les trois premiers.
- **Mise en avant** : La ligne du joueur est surlignée avec un badge "(TOI)".
- **Responsive** : Utilisation de `LayoutBuilder` et `Flexible` pour s'adapter aux écrans iPhone et Tablettes.
- **Pseudos** : Génération en Casse Mixte (ex: "Lapin1234") pour une meilleure lisibilité.
