# Product Requirements Document (PRD) - Baby Learning Road Signs

## 1. Document Overview
- **Project Name:** Baby Learning Road Signs (BLRS)
- **Status:** Draft
- **Version:** 1.0
- **Target Platform:** Mobile (iOS & Android) - Tablets & Smartphones
- **Tech Stack:** Flutter, Firebase, Google AdMob

---

## 2. Product Vision & Goals
### 2.1 Vision
Create a fun, engaging, and educational experience that teaches children aged 7 and under the shapes and meanings of road signs through gamification.

### 2.2 Objectives
- Provide a safe and intuitive learning environment for young children.
- Encourage progression through a "Board Game" style level system.
- Monetize through non-intrusive ads and stars/no-ads purchases.
- Foster healthy competition via an anonymous global leaderboard.

---

## 3. Target Audience
- **Primary:** Children aged 3–7 years old.
- **Secondary:** Parents/Educators looking for educational content.

---

## 4. User Stories
1. **As a Child**, I want to play a game with bright colors and road signs so that I can learn while having fun.
2. **As a Child**, I want to earn stars and points to unlock new levels and see my name on the leaderboard.
3. **As a Child**, I want hints when I'm stuck so I don't get frustrated.
4. **As a Parent**, I want the app to be easy to use and safe (anonymous login).

---

## 5. Functional Requirements

### 5.1 Authentication & Profile
- **Anonymous Authentication:** Automatic Firebase anonymous login on first launch.
- **Profile:** Auto-generated pseudo (6 letters + 4 digits). Users can edit their pseudo.

### 5.2 Core Gameplay (Level System)
- **Board Game Map:** A vertical winding road with milestones (levels 1-10).
- **Progression:** Levels must be unlocked sequentially.
- **Unlocking Cost:** 500 stars (free if already played).
- **Level States:** Visual color-coding based on previous performance (Red: 0-2 correct, Yellow: 3-4, Green: 5).

### 5.3 Level Mechanics (Quiz)
- **Phase Animation :** La voiture arrive sur le niveau -> Transition vers l'écran de quiz.
- **Phase Question :**
    - Un arrière-plan illustré plein écran (Ville & Route) pour une immersion maximale.
    - Panneau affiché dans un encart arrondi à droite.
    - Question : "Quelle forme est associée à ce panneau ?"
    - 3 options de formes en bas (Garanties : la bonne réponse est TOUJOURS présente).
    - Compteur numérique (décompte).
- **Navigation & Sortie :**
    - La barre de navigation est verrouillée pendant le quiz. Le bouton central devient **Rouge** avec un halo lumineux.
    - Quitter nécessite une confirmation ; les étoiles consommées (500) sont perdues en cas d'abandon.
- **Récompenses & Rejouabilité :**
    - Les niveaux réussis avec 10/10 sont rejouables gratuitement (sans gain d'étoiles).
    - Redirection automatique vers la boutique si le solde d'étoiles est insuffisant (< 500).
- **Phase Résultat :**
    - Bilan détaillé des 10 questions avec points gagnés/perdus.
    - Bouton "Retour" vers la carte.

### 5.4 Social & Competition
- **Leaderboard:** Dynamic Top 20 based on max level reached, then total points.
- **Personal Ranking:** Display the user's specific rank even if outside the Top 20.

### 5.5 Monetization (The Shop)
- **Star Packs:** 
    - 1000 étoiles (1,99€)
    - 3000 étoiles (4,99€)
    - 5000 étoiles (6,99€ + 1 jour sans pub)
    - 10000 étoiles (11,99€ + 3 jours sans pub)
- **No-Ads Bundle:** 
    - 7 jours sans pub (1,99€)

### 5.6 Audio & Multimedia
- **Background Music:** Soft, upbeat, and child-friendly background music (royalty-free).
- **Sound Effects (SFX):**
    - Correct answer: "Ding" or sparkly sound.
    - Wrong answer: Soft "Boing" or neutral feedback (avoid scary sounds).
    - Level completion: Fanfare/Cheer.
    - Button clicks: Subtle pop/click.
- **Controls:** Individual toggles for Music and SFX in settings.

---

## 6. Non-Functional Requirements

### 6.1 Performance
- Fast loading times (optimized assets).
- Smooth 60fps animations for the road scrolling.

### 6.2 Security & Compliance
- **GDPR Compliance:** Mandatory consent management for AdMob.
- **Privacy:** No PII collected (anonymous IDs only).

### 6.3 Technical Constraints
- Built with **Flutter** for cross-platform compatibility.
- **Orientation:** **Portrait mode ONLY** for optimized vertical road layout and child ergonomics.
- **Responsiveness:** Full support for Smartphones and Tablets.
    - **Tablet Rule:** Content is centered and constrained to a **600px width maximum** to preserve casual game aesthetics.
- **Data:** **Firebase Firestore** for real-time data and leaderboard.
- **Auth:** **Firebase Auth** for anonymous user tracking.

---

## 7. UI/UX Design (Look & Feel)
- **Style:** Cartoonish, vibrant, and child-friendly.
- **Palette:** 
    - Orange (#f25022)
    - Green (#7fba00)
    - Blue (#00a4ef)
    - Yellow (#ffb900)
- **Controls:** Large, high-contrast buttons for small fingers.
- **Animations:** Subtle micro-interactions and transitions (e.g., car moving, star collection).

---

## 8. Success Metrics (KPIs)
- **User Retention:** Day 1 and Day 7 retention rates.
- **Conversion Rate:** Percentage of users buying stars or "No-Ads".
- **Average Session Duration:** Target > 5 minutes.
- **Progression:** Percentage of users reaching Level 10.

---

## 9. Roadmap
1. **Phase 1:** Core Mechanics (Auth, Level 1, Question logic).
2. **Phase 2:** Feature Completion (Leaderboard, Shop, Settings).
3. **Phase 3:** Polishing & Monetization (AdMob, IAP, Animations).
4. **Phase 4:** Beta Testing & Play Store/App Store Launch.
