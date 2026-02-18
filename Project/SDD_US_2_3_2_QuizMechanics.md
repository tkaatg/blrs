# SDD US 2.3.2 : Mécanique du Quiz (Gameplay)

- **User Story :** "En tant qu'enfant, je veux répondre à un quiz simple pour valider le niveau et gagner des étoiles."
- **Statut :** Validé
- **Référence Design :** Ergo Design System 1.0

---

## 1. Conception Visuelle & Expérience

### 1.1 Déroulement
1. **Transition :** La voiture arrive sur le niveau -> Zoom ou Fade vers l'écran de quiz.
2. **Phase Question :**
   - Affichage de l'image du panneau au centre (taille adaptative).
   - Question audio/texte : "Montre-moi la forme qui correspond".
3. **Phase Réponse :**
   - 3 gros boutons en bas (formes géométriques ou symboles).
   - Feedback immédiat au toucher (Son + Animation).
4. **Phase Résultat :**
   - **Succès :** Explosion de confettis, gain d'étoiles, bouton "Continuer".
   - **Échec :** Animation "Oups", bouton "Réessayer" ou "Indice".

### 1.2 Interface Responsive (Premium UX)
- **Portrait Only.**
- **Layout Split :**
  - **Body :** Panneau à identifier (Encart à droite) + Question textuelle.
  - **Bottom Info Panel (Fixed 100px) :**
    - **Côté Gauche (1/3) :** Chronomètre numérique (Barre de stats).
    - **Côté Droit (2/3) :** Zone dynamique (Indice / Feedback / Bouton Suivant).
  - **Tablette :** Contenu centré max 600px.

---

## 2. Architecture Technique

### 2.1 Modèle de Données (`QuizModel`)
- `Question` :
  - `id` (String)
  - `roadSignImage` (AssetPath)
  - `correctShapeId` (String)
  - `distractors` (List<String>) - IDs des mauvaises réponses.
  - `difficulty` (enum: Easy, Medium, Hard)

### 2.2 Composants Flutter
- `QuizScreen` : Scaffold principal.
- `QuizTimer` : Widget animé (LinearProgressIndicator) gérant le temps (15s).
- `AnswerButton` : Widget interactif avec états (Normal, Correct, Wrong).

### 2.3 Logique Métier (`QuizController` / Provider)
- Gestion du Timer (Ticker).
- Validation de la réponse.
- Calcul du score : `Score = (Temps Restant * 10) + Bonus`.

### 2.4 Garantie de Fiabilité (Anti-Softlock)
- **Injection Directe :** La réponse correcte est systématiquement ajoutée à la liste des options avant l'ajout des distracteurs.
- **Normalisation :** Toutes les IDs de formes sont traitées en minuscules (`.toLowerCase()`) pour correspondre aux données CSV et au mapping des assets.
- **Sécurité :** Si moins de 3 options sont générées par la logique métier, un fallback complète la liste avec des formes aléatoires pour garantir l'affichage de l'UI.

---

## 3. Plan d'Implémentation Finalisé

1. **Setup :** `lib/models/quiz_model.dart` et `lib/screens/quiz_screen.dart`.
2. **Logic :** 
   - `SignService` : Chargement CSV robuste avec fallback intégré (10 questions garanties).
   - `QuizScreen` : Algorithme de sélection des distracteurs par familles visuelles.
   - **Garantie :** La bonne réponse (`correctShapeId`) est injectée systématiquement dans la liste des choix avant le shuffle.
3. **UI :**
   - Background statique immersif (`assets/images/quiz_bg.png`).
   - Feedback visuel : Bordure verte pour correct, rouge pour erreur.
4. **Integration :** Redirection vers la Boutique (`onShopRequested`) si le solde est < 500 étoiles au lancement.

---
*Document rédigé par l'Architecte Technique.*
