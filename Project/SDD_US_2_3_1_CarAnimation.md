# SDD - US 2.3.1 : Animation de la Voiture sur la Route

## 1. Objectif
Implémenter l'animation d'une petite voiture qui se déplace le long du tracé de la route sinueuse (`RoadPainter`) pour rejoindre le niveau sélectionné par l'utilisateur.

## 2. Spécifications Techniques
### 2.1 Modèle de Données
- Pas de changement au modèle `Player` ou `Level`.
- Utilisation de `PathMetric` pour calculer les positions le long du `Path` généré par `RoadPainter`.

### 2.2 Composants UI
- **CarWidget :** Un nouveau widget représentant la voiture (en attendant l'image finale, un `Icon(Icons.directions_car)` avec un style cartoon).
- **AnimationController :** Pour gérer la progression de la voiture (0.0 à 1.0).
- **CurvedAnimation :** Pour donner un effet de vitesse naturel (accélération/décélération).

## 3. Logique d'Animation
1. **Extraction du Path :** Récupérer le `Path` identique à celui du `RoadPainter`.
2. **Calcul de Position :** 
   - Utiliser `path.computeMetrics()` pour obtenir la longueur totale.
   - Utiliser `extractPath()` ou `getPosAndAngle()` pour obtenir les coordonnées (x, y) et l'angle de rotation à un instant T.
3. **Déclenchement :** 
   - L'animation se déclenche lors du clic sur un `LevelNode` déverrouillé.
   - La voiture part de sa position actuelle (dernier niveau complété) jusqu'au nouveau niveau.

## 4. Design Ergonomique (Ergo Design System)
- **Rotation :** La voiture doit "tourner" ses roues/son corps pour suivre les virages de la route.
- **Vitesse :** L'animation doit durer environ 1.5 à 2 secondes pour être bien visible mais pas lassante.
- **Feedback :** Un petit bruit de moteur (US 4.1.1) pourra être ajouté plus tard.

## 5. Cas d'Usage
- L'utilisateur appuie sur le Niveau 2.
- La voiture glisse du Niveau 1 au Niveau 2 en suivant les courbes de la route.
- À l'arrivée, l'écran de Quiz (US 2.3.2) s'ouvre automatiquement.
