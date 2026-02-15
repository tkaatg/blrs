# SDD EPIC 2 : Expérience Utilisateur & Gameplay

- **Projet :** Baby Learning Road Signs (BLRS)
- **Version :** 1.0
- **Statut :** En attente de validation
- **Auteur :** Antigravity

---

## 1. Objectifs
Définir les structures de données et la logique métier pour l'authentification anonyme, la progression sur le plateau de jeu (Board Game) et les mécaniques de quiz.

## 2. Modèle de Données (Firestore)

### 2.1 Collection `players`
Chaque document est identifié par l'ID unique de l'utilisateur Firebase (UID).

| Champ | Type | Description |
| :--- | :--- | :--- |
| `uid` | String | ID Firebase Auth. |
| `pseudo` | String | Mot (6 lettres: Animal/Fleur) + 4 chiffres. |
| `stars` | Number | Stock de monnaie (Défaut: 1500). |
| `points` | Number | Score total cumulé. |
| `maxLevelUnlocked` | Number | Niveau maximum atteint (1 à 10). |
| `stats_levels` | Map | `{ "level_1": score, "level_2": score ... }` |
| `unlocked_levels` | List<Int> | Liste des IDs de niveaux payés/débloqués. |
| `createdAt` | Timestamp | Date de création du compte. |

### 2.2 Collection `questions` (Lecture seule pour l'app)
| Champ | Type | Description |
| :--- | :--- | :--- |
| `id` | String | ID unique. |
| `level` | Number | Niveau associé (1 à 10). |
| `order` | Number | Ordre dans le niveau (1 à 5). |
| `visualSign` | String | URL de l'image du panneau. |
| `visualInterior` | String | URL de l'image intérieure (si applicable). |
| `correctShapeId` | String | ID de la forme géométrique attendue. |

---

## 3. Architecture Logicielle (Services)

### 3.1 `AuthService`
Gère la connexion Firebase et la création du document `player` initial.
- `signInAnonymously()` : Connecte ou reconnecte l'utilisateur.
- `getCurrentPlayer()` : Récupère les données en temps réel depuis Firestore (Stream).

### 3.2 `GameService`
Gère la logique de progression et les scores.
- `unlockLevel(int levelId)` : Vérifie si le joueur a 500 étoiles, les déduit et met à jour `unlocked_levels`.
- `saveLevelResult(int levelId, int correctAnswers, int totalPoints)` : Calcule si le score améliore l'existant et met à jour `stats_levels`.

### 3.3 `AudioService`
- `playBackgroundMusic()` : Lance la boucle musicale joyeuse.
- `playSoundEffect(SFXType type)` : Joue le son correspondant (Ding, Boing, Fanfare).

### 3.4 AdService (Mandatoire)
Gère l'affichage des publicités récompensées (Rewarded Ads) via Google AdMob.
- `initialize()` : Init du SDK AdMob.
- `showRewardedAd(Function onComplete)` : Affiche une pub et exécute le callback (ex: donner l'indice) seulement si la pub est vue en entier.

---

## 4. Logique d'Écran (UI Flow)

### 4.1 Accueil (Board Game)
- **Logique de couleur des bornes :**
    - Gris : Niveau verrouillé.
    - Rouge : Score 0-2 / 5.
    - Jaune : Score 3-4 / 5.
    - Vert : Score 5 / 5.
- **Navigation :** Tap sur une borne -> Vérification d'accès -> Animation de route -> Transition Question.

### 4.2 Écran Question
- **Gestion du Timer :** Instance de `Timer.periodic`. Arrêt immédiat si réponse donnée ou publicité lancée.
- **Réponses :** 1 Bonne réponse + 2 piochées aléatoirement dans une liste globale de formes (pour éviter la prévisibilité).
- **Calcul des points :** `points = secondes_restantes * 100`.

---

## 5. Tests Unitaires (TDD)
Les tests prioritaires porteront sur :
1.  **Générateur de Pseudo :** Vérifier que le format "6 lettres + 4 chiffres" est respecté.
2.  **Calculateur de Score :** Vérifier que le temps restant se transforme correctement en points.
3.  **Gestion des Étoiles :** Vérifier qu'on ne peut pas débloquer un niveau avec un solde négatif.

---

## 6. Liste des mots pour Pseudo (Exemples 6 lettres)
- Animaux : `GIRAFE`, `GUERRE` (non), `REQUIN`, `FOURMI`, `LAMA..` -> `GIRAFE`, `POULPE`, `PHOQUE`, `COUGAR`, `RENARD`, `CASTOR`.
- Fleurs : `TULIPE`, `DAHLIA`, `JASMIN`, `ORCHIS`, `PINSON` (non).
- *Note : Utilisation d'une liste statique robuste dans le code.*

## 7. Validation des Coûts (Cohérence PRD/CDC)
- **Déblocage niveau :** 500 étoiles (gratuit si déjà fait).
- **Indice :** 20 étoiles OU Pub.
- **Continuer après erreur :** 25 étoiles OU Pub.
- **Relance (+10s) :** 50 étoiles OU Pub.

## 8. Validation requise
- La liste des mots de 6 lettres sera codée en dur pour éviter une dépendance réseau au démarrage.
