__TON RÔLE__

Ton rôle est de créer une application mobile éducative en Flutter qui permet à de jeunes enfants \(7 ans et moins\) d’apprendre les formes des panneaux routiers à travers un jeu interactif chronométré avec système de progression, étoiles, points et classement en ligne\.

__Baby Learning Road Signs \- Cahier des Charges Technique__

__1\) Écran de Chargement__

- État : Public
- Composants principaux :
	- Logo stylisé “Baby Learning Road Signs”
	- Fond patchwork illustré de panneaux routiers \(léger flou / opacité réduite\)
	- Indicateur de chargement animé

__2\) Accueil \(Board Game des niveaux\)__

- État : Protégé \(auth anonyme Firebase automatique\)
- Composants principaux :
	- Top bar persistante
	- Route sinueuse verticale type board game
	- Bornes kilométriques numérotées \(1 à 10\)
	- Scroll vertical
	- États visuels des niveaux :
		- 0–2 bonnes réponses : rouge
		- 3–4 bonnes réponses : jaune
		- 5 bonnes réponses : vert
	- Niveau 1 débloqué par défaut
	- Déblocage progressif
	- Coût : 500 étoiles \(gratuit si déjà joué\)

__3\) Écran Niveau \(Animation Route\)__

- État : Protégé
- Composants principaux :
	- Animation route horizontale qui défile
	- Arrêt automatique au panneau
	- Transition vers écran question

__4\) Écran Question__

- État : Protégé
- Composants principaux :
	- Question : “Quelle est la forme correspondante à ce panneau ?”
	- Image panneau \(centre écran\)
	- 3 boutons formes \(1 correcte \+ 2 aléatoires\)
	- Position aléatoire de la bonne réponse
	- Compte à rebours 15 secondes
	- Bouton indice :
		- 20 étoiles \(si solde suffisant\)
		- ou publicité \(pause timer\)
	- Calcul points :
		- P = temps restant × 100
	- Cas succès :
		- Message “Bravo tu as gagné P points”
		- Bouton “Question suivante”
	- Cas erreur :
		- Message “Perdu \!”
		- Boutons recommencer :
			- 25 étoiles
			- publicité
	- Cas temps écoulé :
		- Message “Temps écoulé \!”
		- Relancer 10 secondes :
			- 50 étoiles
			- publicité

__5\) Écran Fin de Niveau__

- État : Protégé
- Composants principaux :
	- Récapitulatif des 5 questions
	- Statut \(gagné / perdu / temps\)
	- Points par question
	- Total niveau
	- Boutons :
		- Accueil \(avec publicité\)
		- Niveau suivant \(avec publicité\)

__6\) Classement__

- État : Protégé
- Composants principaux :
	- Top 20 joueurs triés par :
		1. niveau\_max\_debloque \(desc\)
		2. points \(desc\)
	- Si joueur hors top 20 :
		1. Affichage de sa position réelle
	- Données fictives au démarrage

__7\) Magasin__

- État : Protégé
- Composants principaux :
	- Achat étoiles :
		- 1000 étoiles : 1,99€
		- 2000 étoiles : 2,99€
		- 3000 étoiles : 3,99€
	- Suppression publicité :
		- 1 semaine : 1,99€
		- 1 mois : 5,49€
		- 1 trimestre : 7,99€
	- Intégration paiements in\-app

__8\) Paramètres__

- État : Protégé
- Composants principaux :
	- Édition pseudo
	- Langue \(FR / EN\)
	- Sons on/off
	- Musique on/off
	- Mode dark on/off

__9\) Top Bar \(Présente sur tous les écrans protégés\)__

- Pseudo joueur \+ icône crayon
- Compteur étoiles
- Compteur points \+ icône podium
- Icône magasin
- Icône paramètres

__Configuration Firebase__

Authentification :

- Authentification anonyme automatique au lancement

Collections :

__joueurs__

- uid
- pseudo \(format : 6 lettres \+ 4 chiffres auto\-généré\)
- etoiles \(default : 1500\)
- points \(default : 0\)
- niveau\_max\_debloque \(default : 1\)
- date\_creation
- langue
- sons\_actifs
- musique\_active
- dark\_mode
- suppression\_pub\_expiration

__questions__

- id
- niveau \(1–10\)
- ordre\_question \(1–5\)
- visuel\_panneau
- visuel\_interieur
- libelle\_panneau
- id\_forme\_reference

__formes__

- id\_forme
- visuel\_forme
- type\_panneau \(pour indice\)

Classement :

- Calcul dynamique depuis joueurs
- Limité au Top 20
- Affichage position joueur

Publicité :

- Intégration Google AdMob
- Gestion RGPD obligatoire \(consentement utilisateur\)

__Design__

Style :

- Cartoon
- Couleurs vives
- Boutons larges et arrondis
- Interface adaptée enfants 7 ans et moins

Palette :

- Orange : \#f25022
- Vert : \#7fba00
- Bleu : \#00a4ef
- Jaune : \#ffb900

Inspiration :

- Board game vertical avec route sinueuse
- Route animée dans les niveaux
- Fond patchwork panneaux stylisés

Responsive :

- Mobile et tablette (iOS et Android)
- **Orientation :** Portrait uniquement (fixé logiciellement)
- **Adaptation Tablette :** Largeur maximale de contenu fixée à **600px** pour le plateau de jeu afin de préserver l'ergonomie.

__Règles de Développement__

- Commencer par configurer Firebase\.
- Implémenter l’authentification anonyme\.
- Structurer le projet Flutter par dossiers \(screens, widgets, services, models\)\.
- Créer tous les écrans avant d’implémenter la navigation\.
- Implémenter la logique étoiles et points séparément\.
- Implémenter la gestion des timers proprement \(dispose controllers\)\.
- Tester les scénarios erreur / temps écoulé / relance\.
- Assurer conformité RGPD\.
- Optimiser les performances \(images compressées\)\.

