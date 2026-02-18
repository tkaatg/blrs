# Ergo Design System - Baby Learning Road Signs (BLRS)

- **Role :** UX/UI Senior Director
- **Version :** 1.0
- **Objectif :** Établir les standards d'ergonomie et de design pour une accessibilité maximale aux jeunes enfants (3-7 ans).
- **Philosophie :** "Jouer pour apprendre, sans frustration."

---

## 1. Principes Fondamentaux de l'UX Enfant

### 1.1 Simplicité Cognitive
- **Zéro Texte Vital :** L'enfant doit pouvoir jouer sans savoir lire. Les instructions passent par l'icône, la couleur et le son.
- **Chemin Unique :** Éviter les menus imbriqués. L'interface doit être linéaire (Plateau > Niveau > Quiz > Résultat).
- **Iconographie Littérale :** Utiliser des symboles universels et figuratifs (ex: une étoile pour la monnaie, un haut-parleur pour le son).

### 1.2 Accessibilité Motrice
- **Hit Zones XXL :** Les boutons doivent avoir une zone tactile minimale de **80x80 pixels**.
- **Gestes Simples :** Prioriser le "Tap" simple. Éviter le "Long Press" ou le "Drag & Drop" complexe qui peut être frustrant pour les petites mains.
- **Zones de Repos :** Laisser des marges pour éviter les clics accidentels lors de la manipulation de la tablette/smartphone.

### 1.3 Feedback & Gratification
- **Réaction Immédiate :** Chaque action doit déclencher une réaction visuelle (animation) et sonore (sfx).
- **Renforcement Positif :** Même en cas d'erreur, le feedback doit être doux ("Oups !") et non punitif. Les victoires doivent être célébrées (fanfares, pluie d'étoiles).

---

## 2. Charte Graphique (UI System)

### 2.1 Palette de Couleurs (PRD Compliance)
| Couleur | Code Hex | Usage | Psychologie |
| :--- | :--- | :--- | :--- |
| **Orange** | `#F25022` | Actions principales (Play, Next) | Énergie, Excitation |
| **Vert** | `#7FBA00` | Validation, Succès, Niveaux réussis | Sécurité, Nature |
| **Bleu** | `#00A4EF` | Fond, Boutons secondaires | Calme, Confiance |
| **Jaune** | `#FFB900` | Étoiles, Indices, Attention | Joie, Récompense |

### 2.2 Typographie
- **Police :** `Outfit` ou `Roboto Rounded` (ou équivalent sans empattement aux bords arrondis).
- **Taille :** Minimum 18pt pour le corps, 32pt pour les titres.
- **Style :** Éviter l'italique ou les polices trop scriptées. Préférer le gras (Bold) pour la lisibilité.

---

## 3. Composants Standards

### 3.1 Les Boutons "Kid-Friendly"
- **Bords Arrondis :** Rayon de courbure de 24px minimum pour un aspect "jouet".
- **Effet 3D/Ombre :** Légère ombre portée vers le bas pour indiquer qu'on peut appuyer dessus (affordance).
- **États :**
    - `Normal` : Couleur vive.
    - `Pressed` : Zoom arrière (0.95) + assombrissement.
- **Paramètres / Cartes :** Rayon de courbure de **20px** pour une cohérence visuelle "Premium Toy".

### 3.2 Bornes de Niveaux (Milestones)
- Diamètre : 100px.
- Contenu : Chiffre large et lisible.
- Indicateur de statut : Halo lumineux pour le niveau "Actuel".

### 3.3 Mascottes "Les Formes Rigolotes"
Pour humaniser l'apprentissage, l'application utilise trois personnages récurrents :
- **Rondy (Rouge) :** Un cercle rouge avec des bras fins et un grand sourire.
- **Carré-Vite (Bleu) :** Un carré bleu un peu timide mais très savant.
- **Trigo (Jaune) :** Un triangle jaune dynamique et farceur.
- *Usage :* Ils apparaissent le long de la route pour encourager l'enfant et servent de base aux questions de quiz.

### 3.4 Décor Cartoon (Environment)
- **Richesse Visuelle :** La route ne doit pas être déserte. Elle traverse des micro-environnements :
    - Zones urbaines (Petites maisons colorées).
    - Zones nature (Arbres ronds, fleurs).
    - Signalisation (Panneaux indicateurs amusants).
- **Parallaxe :** Les éléments de décor bougent à des vitesses différentes pour créer de la profondeur.

---

## 6. Structure de Navigation Globale (Premium UI)

Inspiré des meilleurs jeux casuals, l'application utilise une barre de navigation basse (Bottom Navigation) pour un accès rapide aux fonctions clés.

### 6.1 Bottom Navigation Bar
- **Boutique (Shop) :** Accès aux achats in-app. Icône de coffre ou de stand de marché. Badge rouge pour les promotions.
- **Accueil (Home/Board) :** L'onglet central. Icône de maison ou de route. C'est le plateau de jeu principal.
- **Ami·es (Social/Rank) :** Classement et aspect social. Icône de personnages.
- **Paramètres (Settings) :** Réglages techniques. Icône d'engrenage.

### 6.2 Top Bar "Resource Header"
Fixe en haut de l'écran sur la plupart des pages :
- **Avatar/Pseudo :** Accès au profil.
- **Étoiles :** Affichage de la monnaie avec un bouton **(+)** vert pour achat direct.
- **Bouton No-Ads :** Un petit raccourci (icône TV barrée) pour supprimer les publicités en un clic.

### 6.3 Style "Bubbly/Glossy"
- **Gradients :** Utiliser des dégradés linéaires doux.
- **Bordures :** Bordures blanches épaisses (2-3px) autour des boutons pour les faire ressortir.
- **Gloss :** Un reflet blanc semi-transparent sur la moitié supérieure des gros boutons et éléments de monnaie.

---

## 7. Support Appareils & Responsivité

### 7.1 Orientation Unique : Portrait
- L'application est exclusivement conçue pour le mode **Portrait**. Le mode paysage est désactivé pour simplifier la navigation de l'enfant et optimiser l'affichage vertical de la route.

### 7.2 Mise à l'échelle Adaptive (Mobile & Tablette)
- **Largeur Max (Tablette) :** Sur tablette, le plateau de jeu ne doit pas s'étirer à l'infini. Il est centré avec une largeur maximale de **600px** pour conserver l'aspect "Board Game".
- **Unités Relatives :** Toutes les positions (Boutons, Voiture, Mascottes) sont calculées en pourcentage de la largeur/hauteur du plateau (Scaling Factor) pour garantir un alignement parfait peu importe la densité de pixels de l'écran.
- **Header/Footer :** Les barres de navigation s'adaptent en Largeur (Fill) tandis que le contenu central reste proportionnel.
