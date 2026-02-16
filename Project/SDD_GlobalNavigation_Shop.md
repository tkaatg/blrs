# SDD - Menu Global & Expérience Boutique

## 1. Objectif
Implémenter une navigation globale robuste et une interface de boutique premium inspirée des standards du jeu mobile casual (Crozzle, Royal Match).

## 2. Architecture de Navigation
### 2.1 MainNavigationScreen
- **Conteneur :** Utilise un `Scaffold` avec un `IndexedStack` pour maintenir l'état des onglets sans rechargement.
- **Barre de Navigation Basse (Custom BottomNav) :**
    - 4 onglets : Boutique, Accueil, Ami·es, Réglages.
    - Style : Fond teal foncé, icônes colorées à la sélection, bordure blanche premium.
- **Top Resource Bar (Overlay) :**
    - Persistant sur l'accueil et les autres onglets hors boutique.
    - Affiche le pseudo et le compteur d'étoiles.
    - Bouton **(+)** vert : Raccourci direct vers l'onglet Boutique.

## 3. Composants UI Premium
### 3.1 BubblyButton
- Widget réutilisable avec un effet de relief (gloss), bordure blanche épaisse et ombre portée.
- Utilisé pour les actions d'achat dans la boutique.
- Feedback visuel immédiat lors du clic.

### 3.2 ShopScreen
- **Lignes de produits :** Cartes blanches épurées.
- **Bouton No-Ads :** Mise en avant d'une offre pour supprimer les publicités avec une icône visuelle claire (TV barrée).

## 4. Données & Persistance
- Utilisation du modèle `Player` pour synchroniser le nombre d'étoiles affiché dans la barre de ressources avec les données réelles (mockées en mode Démo, synchronisées via Firestore en mode normal).

## 5. Ergonomie (Ergo Design System)
- Hit zones respectées (80x80 pixels pour les onglets).
- Couleurs distinctes par fonctionnalité pour faciliter la mémorisation cognitive de l'enfant.
