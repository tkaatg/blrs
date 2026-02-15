# Gouvernance & Bonnes Pratiques - BLRS

Ce document définit les règles de collaboration entre l'utilisateur et l'agent Antigravity.

---

## 1. Organisation du Code (Flutter)
- **Architecture :** Dossier `lib/` structuré par type.
    - `models/` : Classes de données (ex: `Player`, `Question`).
    - `services/` : Logique externe (Firebase, Audio, API).
    - `screens/` : Écrans complets de l'application.
    - `widgets/` : Composants réutilisables.
- **State Management :** À définir (Provider, Riverpod ou Bloc). Par défaut : **Provider** pour la simplicité.

## 2. Nomenclature (Naming Conventions)
- **Classes :** `UpperCamelCase` (ex: `RoadSignGame`).
- **Variables/Fonctions :** `lowerCamelCase` (ex: `calculateScore`).
- **Fichiers :** `snake_case` (ex: `home_screen.dart`).
- **Assets :** `snake_case` (ex: `car_animation.json`).

## 3. Règles de Codage & Qualité
- **Linting :** Utilisation des `flutter_lints` standards.
- **Documentation :** Chaque classe et fonction publique doit avoir un commentaire Docstring (`///`).
- **Clean Code :** Fonctions de maximum 30 lignes. Séparation stricte UI et Logique.

## 4. Stratégie de Test (TDD)
- **Tests Unitaires :** Obligatoires pour toute la logique de calcul (points, minuteur).
- **Tests de Widget :** Pour les composants interactifs clés.
- **Workflow :** Les tests doivent passer (`flutter test`) avant chaque commit/push via Antigravity.

## 5. Process de Revue & Production
- **Revue de Code :** Antigravity analyse chaque changement pour détecter les "smells" ou incohérences avec le PRD.
- **Livraison :** Automatisée via `antigravity release` (génération APK/IPA).
- **Environnements :**
    - `Dev` : Local et Firestore Emulator.
    - `Production` : Firebase Live.

---

## 6. Rôles des Agents (Multi-Agent Simulation)
Antigravity peut endosser plusieurs rôles selon le besoin :
- **Architecte :** Définit les structures SDD et les modèles de données.
- **Développeur :** Écrit le code Flutter et implémente les fonctionnalités.
- **QA Tester :** Rédige et exécute les plans de tests unitaires et UI.
- **Product Owner :** S'assure de l'adéquation avec le PRD et le Cahier des Charges.

---

## 7. Gestion des Skills
J'utilise des bibliothèques de compétences (Skills) pour :
- **SDD :** Modèles de documents de conception logicielle.
- **TDD :** Patterns de tests unitaires Dart/Flutter.
- **Firestore :** Règles de sécurité et indexations optimisées.
