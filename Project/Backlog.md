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
- [DONE] **BUG-002 (recette 20/02) :** Correction du débordement de la barre de navigation sur les petits écrans (remplacement du `SizedBox(width:75)` fixe par `Expanded` dans `_buildNavItem`).
- [DONE] **UI-001 (recette 20/02) :** Refonte complète de l'UX du quiz :
  - Décompte 3-2-1 centré dans le ciel, coloré par chiffre (orange/ambre/rouge), effet pulse+scale animé.
  - Zone panneau octogonale (`OctagonSignPainter`) avec contour pointillé gris collé.
  - Casino démarre dès l'apparition du panneau (400ms), 12 fps, séquence d'arrêt 1s/1.5s/2s.
  - Route animée via `fond-anime.gif` (GIF nativement animé).
  - Intitulé question toujours visible : "Quiz X - Question Y/Z : Trouver le bon panneau !" (fs 16 bold).
  - Zone feedback à hauteur fixe (46px) pour éviter les décalages de layout.
  - Messages Gagné/Perdu/Temps terminé en 22px bold avec espace réservé.
  - Bouton Indice désactivé (grisé) pendant l'animation d'intro.
  - Contrainte largeur 600px sur grands écrans.
- [DONE] **BUG-003 (recette 21/02) :** Correction layout quiz — crash `Expanded` imbriqués dans `Row` (infinite constraints). Refactoring `_buildOptionsBox` avec `Flexible` + `SizedBox` gap.
- [DONE] **UI-002 (recette 21/02) :** Bilan quiz clarifié — affichage distinct du brut gagné, de la déduction indice (− 20 ⭐ par indice) et du net crédité (`= +X ⭐ crédités`).
- [DONE] **UI-003 (recette 21/02) :** GIF route rechargé à chaque question via `ValueKey(_gifSeed)` (force la reconstruction du widget `Image.network` → redémarrage du GIF).
- [DONE] **BUG-004 (recette 21/02) :** `hintUsed` enregistré sur timeout — la déduction de 20 ⭐ s'applique même si le temps est écoulé.
- [DONE] **UI-004 (recette 21/02) :** Timer affiche `00:00` sur timeout + bordure orange clignotante sur la bonne réponse.
- [DONE] **UI-005 (recette 21/02) :** Espacement entre les 3 cartes-formes augmenté à 20px — meilleure séparation visuelle et confort tactile.
- [DONE] **UI-006 (recette 21/02) :** Dialog de lancement de niveau simplifié — suppression badge cercle + bouton Annuler, titre style BubblyTitle, coût avec icône étoile inline, bouton "C'EST PARTI !" pleine largeur.
- [DONE] **BUG-005 (recette 23/02) :** Fix bug scoring classement — persistance Firestore immédiate lors de l'affichage du bilan pour éviter la perte de points si l'utilisateur change d'onglet sans cliquer sur "RETOUR".
- [DONE] **UI-007 (recette 23/02) :** Unification du naming — renommage de "Réglages" en "Paramètres" dans toute l'application.


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
- [DONE] **US 4.1.1 :** Moteur Audio & SFX. (SDD: [SDD_US_4_1_1_AudioEngine_SFX.md](SDD_US_4_1_1_AudioEngine_SFX.md))
- [DONE] **US 4.1.2 :** Playlist & Musique. (SDD: [SDD_US_4_1_2_MusicSystem.md](SDD_US_4_1_2_MusicSystem.md))
- [DONE] **US 4.1.3 :** Feedback Haptique. (SDD: [SDD_US_4_1_3_HapticFeedback.md](SDD_US_4_1_3_HapticFeedback.md))
- [DONE] **US 4.1.4 :** Réactivité des Réglages. (SDD: [SDD_US_4_1_4_AudioSettingsIntegration.md](SDD_US_4_1_4_AudioSettingsIntegration.md))

---

## EPIC 5 : Monétisation & Gestion
**Définition :** Boutique, réglages et monétisation technique.

### Feature 5.1 : Boutique (Shop)
- [DONE] **US 5.1.1 :** En tant qu'utilisateur, je veux voir des packs d'étoiles avec un design premium (Bubbly) pour m'inciter à l'achat.
- [DONE] **US 5.1.2 :** En tant qu'utilisateur, je veux voir une offre pour supprimer les publicités de manière permanente ou temporaire.

### Feature 5.2 : Paramètres
- [DONE] **US 5.2.1 :** En tant qu'utilisateur, je veux changer mon pseudo (géré par format/validation) et choisir mon avatar parmi une sélection de mascottes.
- [DONE] **US 5.2.2 :** En tant qu'utilisateur, je veux changer la langue du jeu (FR/EN) et activer/désactiver les sons, musiques et vibrations.

### Feature 5.3 : Monétisation In-App (RevenueCat)
- **US 5.3.1 :** En tant que développeur, je veux installer et configurer le SDK RevenueCat (Flutter) pour gérer les achats in-app sur iOS et Android.
- **US 5.3.2 :** En tant que développeur, je veux brancher les produits App Store Connect / Google Play Console (packs d'étoiles, suppression de pub) sur RevenueCat.
- **US 5.3.3 :** En tant qu'utilisateur, je veux pouvoir acheter un pack d'étoiles ou l'offre sans pub, avec confirmation de paiement et attribution côté serveur.

### Feature 5.4 : Publicité (AdMob)
- **US 5.4.1 :** En tant que développeur, je veux installer et configurer le SDK Google AdMob (Flutter) avec les unités publicitaires (App ID, Ad Unit ID) pour iOS et Android.
- **US 5.4.2 :** En tant qu'utilisateur, je veux voir une publicité rewarded vidéo quand je clique sur "Retour" en fin de niveau, avec crédit des étoiles après visionnage complet.
- **US 5.4.3 :** En tant qu'utilisateur, je veux voir une publicité rewarded vidéo dans la boutique pour obtenir 500 étoiles gratuites.
- **US 5.4.4 :** En tant que développeur, je veux supprimer l'overlay de simulation publicitaire et le remplacer par les vraies publicités AdMob.

---

## EPIC 6 : Tracking, Conformité & Distribution
**Définition :** Analytics, politique de confidentialité et déploiement sur les stores.

### Feature 6.1 : Tracking & Analytics (BigQuery)
- **US 6.1.1 :** En tant que développeur, je veux définir un schéma d'events analytiques (`quiz_started`, `question_answered`, `hint_used`, `level_completed`, `purchase_initiated`, `ad_watched`) couvrant les parcours clés.
- **US 6.1.2 :** En tant que développeur, je veux implémenter une API JSON (Cloud Functions ou Cloud Run) qui reçoit les events depuis le client Flutter et les écrit dans BigQuery.
- **US 6.1.3 :** En tant que développeur, je veux que tous les events soient agrégés (aucun identifiant personnel, uniquement des données anonymisées de gameplay).

### Feature 6.2 : Politique de Confidentialité
- **US 6.2.1 :** En tant qu'utilisateur (parent), je veux accéder à une politique de confidentialité claire précisant : quelles données sont collectées (uniquement agrégées, sans ID perso), dans quel but (améliorer le jeu), qu'aucune donnée n'est vendue ni partagée à des tiers à des fins publicitaires, et comment contacter le développeur pour suppression / questions.
- **US 6.2.2 :** En tant que développeur, je veux intégrer la page de politique de confidentialité dans l'écran Réglages (bouton "Confidentialité" existant) et la soumettre lors de la mise en revue App Store / Play Store.

### Feature 6.3 : Distribution (App Store & Play Store)
- **US 6.3.1 :** En tant que développeur, je veux créer et configurer l'application sur App Store Connect (identifiant, catégorie, âge PEGI, captures d'écran, description FR/EN).
- **US 6.3.2 :** En tant que développeur, je veux créer et configurer l'application sur Google Play Console (fiche store, politique de confidentialité, classification de contenu).
- **US 6.3.3 :** En tant que développeur, je veux générer les builds de production iOS (`.ipa`) et Android (`.aab`) et les soumettre en révision sur les deux stores.
- **US 6.3.4 :** En tant que développeur, je veux configurer un pipeline CI/CD minimal (ex : GitHub Actions ou Fastlane) pour automatiser les builds et déploiements.
