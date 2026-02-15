# Workflow de Production Structuré - Baby Learning Road Signs

Ce document définit notre méthodologie de travail en combinant le guide @[Process.md] avec des pratiques d'ingénierie rigoureuses (SDD, TDD) et nos outils tiers (Linear, Firebase, Google Cloud).

---

## 1. Planification & Kanban (Linear)
Tous les développements commencent par un ticket dans **Linear**.
- **Issue Naming:** `[FEAT/FIX/CHORE] : Description courte`
- **Labels:** `Firebase`, `Flutter-UI`, `Logic`, `Audio`, `Bugs`.
- **Kanban Flow:** Backlog -> Todo -> In Progress -> Review -> Done.

## 2. Conception Logicielle (SDD - Software Design Document)
Avant de coder une fonctionnalité complexe (ex: Système de points, Leaderboard) :
1. Créer un court document de conception dans `docs/design/`.
2. Définir :
    - **Data Model :** Structure Firestore (collections, champs).
    - **Interface :** Signature des méthodes du service.
    - **Logique :** Algorithme ou diagramme d'état si nécessaire.

## 3. Développement Guidé par les Tests (TDD - Test Driven Development)
Pour la logique métier (Services, Models) :
1. **Red :** Écrire un test unitaire (`test/unit/..._test.dart`) qui échoue.
2. **Green :** Implémenter le minimum de code pour faire passer le test.
3. **Refactor :** Optimiser le code tout en gardant le test au vert.
4. **Widget Testing :** Pour les composants UI critiques (ex: Timer, Bouton Indice).

## 4. Intégration Audio (Royalty-Free)
L'ajout de sons suit ce process :
1. **Sourcing :** Utiliser des sons libres de droits (ex: Pixabay, Freesound, Kenney.nl).
2. **Standardisation :** Formats `.mp3` ou `.wav` légers.
3. **Implémentation :** Utiliser `audioplayers` ou `flame_audio`.
4. **Configuration :** Toujours lier les sons aux toggles "Musique" et "SFX" du menu Paramètres.

## 5. Intégration Cloud & Firebase
- **Google Cloud Console :** Utilisé pour la gestion des clés API AdMob et les permissions IAP.
- **Firebase :** 
    - `auth` pour les comptes anonymes.
    - `firestore` pour le leaderboard et les datas joueurs.
    - `app-distribution` pour les builds de staging (utilisé via Antigravity deploy).

## 6. Cycle Antigravity (Rappel du Process.md)
1. `antigravity start-task [LINEAR-ID]` : Branche automatique.
2. Développement Flutter + TDD.
3. `flutter test` : Validation locale obligatoire.
4. `antigravity sync` : Push en staging.
5. `antigravity release` : Tag et déploiement final.

---

## Synthèse Méthodologique
| Étape | Méthode | Outil |
| :--- | :--- | :--- |
| **Gestion** | Agile / Kanban | **Linear** |
| **Design** | **SDD** | Markdown / Figma |
| **Code** | **TDD** | Flutter / Dart Test |
| **Infrastructure** | Serverless | **Firebase / GC** |
| **Release** | GitOps | **Antigravity** |
