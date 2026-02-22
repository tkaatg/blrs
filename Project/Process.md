# Process de Travail — Baby Learning Road Signs (BLRS)

Ce document décrit le cycle de travail collaboratif entre l'utilisateur et l'agent Antigravity.

---

## 1. Démarrage de Session

À chaque nouvelle session de travail, Antigravity doit :
1. Lire `AGENTS.md` (à la racine du projet)
2. Consulter le `Project/Backlog.md` pour voir les User Stories en cours
3. Identifier l'US ou le bug à traiter
4. Lire le SDD correspondant dans `Project/` si disponible

---

## 2. Cycle de Développement

```
[Backlog] → [SDD] → [Code] → [Test] → [Revue] → [Done]
```

### Étape 1 — Analyse
- Lire la User Story et son SDD associé
- Identifier les fichiers Dart concernés
- Signaler toute incohérence avec le PRD avant de coder

### Étape 2 — Implémentation
- Respecter la **règle du Scaffold unique** (voir `AGENTS.md`)
- Respecter la nomenclature `snake_case` pour fichiers, `UpperCamelCase` pour classes
- Pas de logique métier dans les widgets UI

### Étape 3 — Validation
- Lancer `flutter run -d chrome` et vérifier qu'il n'y a **aucune erreur dans les logs**
- Vérifier visuellement : TopBar en haut, BottomNav en bas, contenu centré
- En cas d'erreur RenderFlex : vérifier qu'aucun Scaffold n'est imbriqué

### Étape 4 — Documentation
- Mettre à jour le SDD si la conception a évolué
- Mettre à jour le Backlog (`Project/Backlog.md`) en changeant le statut
- **Mettre à jour l'historique** (`Project/ressources/changes_history.md`) avant de proposer le commit à l'utilisateur

---

## 3. Règles de Debug

### Problème : BottomNav au mauvais endroit / Contenu invisible
→ **Cause probable :** Scaffold imbriqué dans un écran fils  
→ **Solution :** Supprimer le `Scaffold` de l'écran fils, retourner le contenu directement

### Problème : RenderFlex overflowed
→ **Cause probable :** Row/Column avec contenu trop large sans `Expanded` ou `Flexible`  
→ **Solution :** Ajouter `Expanded`, limiter la largeur, ou utiliser `mainAxisSize: MainAxisSize.min`

### Problème : Page blanche
→ **Cause probable :** Exception non catchée au démarrage (voir console Flutter)  
→ **Solution :** Lire les logs complets, identifier la ligne de l'erreur

---

## 4. Gestion des Assets

Les assets sont dans `assets/images/` :
- **Avatars :** `avatar_carre.png`, `avatar_triangle.png`, `avatar_losange.png`, `avatar_rond.png`
- **Board :** `board_background.png` (répété 4x pour la hauteur du parcours)

Tout nouvel asset doit être déclaré dans `pubspec.yaml` sous `assets:`.

---

## 5. Structure des User Stories (Backlog)

Chaque US suit le format :
```
ID : US-X.X.X
Titre : [Court, actionnable]
Statut : [ ] Todo / [~] In Progress / [x] Done
SDD : Lien vers le SDD
Description : En tant que [persona], je veux [action] afin de [bénéfice]
```

---

## 6. Contacts & Références

| Ressource | Chemin |
|---|---|
| PRD | `Project/PRD.md` |
| Backlog | `Project/Backlog.md` |
| Design System | `Project/Ergo_Design_System.md` |
| Navigation | `Project/SDD_GlobalNavigation.md` |
| Gouvernance | `Project/Governance.md` |
| AGENTS Guide | `AGENTS.md` (racine) |
