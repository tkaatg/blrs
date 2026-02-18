# Backlog Agile - Baby Learning Road Signs (BLRS)

Ce document contient le découpage en Epics, Features et User Stories pour importation dans Linear.

---

## EPIC 1 : Infrastructure & Fondation
**Définition :** Mise en place de l'environnement technique de base et des services cloud.

### Feature 1.1 : Setup Technique
- **US 1.1.1 :** En tant que développeur, je veux initialiser le projet Flutter avec une architecture propre (Folder structure) afin de faciliter la maintenance. 
- **US 1.1.2 :** En tant que développeur, je veux lier le projet à Firebase (Auth, Firestore) pour gérer la persistance des données.
- **US 1.1.3 :** En tant que développeur, je veux configurer les environnements (Dev, Staging, Prod) pour sécuriser les déploiements.

---

## EPIC 2 : Expérience Utilisateur & Gameplay
**Définition :** Cœur du jeu et progression de l'enfant.

### Feature 2.1 : Authentification Anonyme
- **US 2.1.1 :** En tant qu'utilisateur, je veux être connecté automatiquement de façon anonyme afin de commencer à jouer sans formulaire.

### Feature 2.2 : Menu Principal & Progression (Board Game)
- [DONE] **US 2.2.0 :** En tant qu'utilisateur, je veux naviguer entre la boutique, le jeu, le classement et les réglages via une barre de navigation basse colorée et une Top Bar accessible (Pseudo, Avatar, Étoiles).
- [DONE] **US 2.2.1 :** En tant qu'enfant, je veux voir une route sinueuse avec des niveaux numérotés pour comprendre ma progression.
- [DONE] **US 2.2.2 :** En tant qu'enfant, je veux voir le statut de mes niveaux (Rouge/Jaune/Vert) selon mes scores précédents.
- [DONE] **US 2.2.3 :** En tant qu'enfant, je veux dépenser 500 étoiles pour lancer un nouveau quiz.
- [DONE] **US 2.2.4 :** En tant qu'enfant, je veux rejouer gratuitement les niveaux déjà réussis (10/10).

### Feature 2.3 : Mécanique de Jeu (Quiz)
- [DONE] **US 2.3.1 :** En tant qu'enfant, je veux voir une animation de voiture qui s'arrête devant un panneau pour introduire la question.
- [DONE] **US 2.3.2 :** En tant qu'enfant, je veux choisir la forme correspondante au panneau parmi 3 options (Garanties : solution toujours présente).
- [DONE] **US 2.3.3 :** En tant qu'enfant, je veux voir un minuteur de 15 secondes pour ajouter du challenge.
- [DONE] **BUG-001 :** Correction d'une erreur de compilation et renforcement de la sécurité des options.
- [DONE] **US 2.3.4 :** En tant qu'enfant, je veux utiliser un indice (supprimer des réponses) en échange d'étoiles ou d'une publicité.

---

## EPIC 3 : Gamification & Social
**Définition :** Système de récompenses et compétition.

### Feature 3.1 : Système de Points & Étoiles
- [DONE] **US 3.1.1 :** En tant qu'enfant, je veux gagner des points basés sur ma rapidité pour grimper dans le classement.
- [DONE] **US 3.1.2 :** En tant qu'enfant, je veux accumuler des étoiles à chaque victoire pour les utiliser dans la boutique ou pour des indices.

### Feature 3.2 : Classement (Leaderboard)
- [DONE] **US 3.2.1 :** En tant qu'utilisateur, je veux voir le Top 10 mondial OU le Top 3 suivi de ma position contextuelle (+/- 2 voisins) pour me situer dans la compétition.
- [DONE] **US 3.2.2 :** En tant que développeur, je veux intégrer 5000 bots (seeding) selon une pyramide de scores cohérente pour simuler une communauté active dès le lancement.

---

## EPIC 4 : Audio & Immersion
**Définition :** Univers sonore pour l'engagement.

### Feature 4.1 : Univers Sonore
- **US 4.1.1 :** En tant qu'enfant, je veux entendre une musique joyeuse et des bruitages (victoire/erreur) pour rendre l'expérience vivante.
- **US 4.1.2 :** En tant qu'utilisateur, je veux pouvoir couper la musique ou les sons indépendamment dans les paramètres.

---

## EPIC 5 : Monétisation & Gestion
**Définition :** Boutique et réglages.

### Feature 5.1 : Boutique (Shop)
- [DONE] **US 5.1.1 :** En tant qu'utilisateur, je veux voir des packs d'étoiles avec un design premium (Bubbly) pour m'inciter à l'achat.
- [DONE] **US 5.1.2 :** En tant qu'utilisateur, je veux voir une offre pour supprimer les publicités de manière permanente ou temporaire.

### Feature 5.2 : Paramètres
- [DONE] **US 5.2.1 :** En tant qu'utilisateur, je veux changer mon pseudo (géré par format/validation) et choisir mon avatar parmi une sélection de mascottes.
- [DONE] **US 5.2.2 :** En tant qu'utilisateur, je veux changer la langue du jeu (FR/EN) et activer/désactiver les sons, musiques et vibrations.
