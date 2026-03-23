# 🚀 Guide Complet - Lancement App Store

## 📋 TABLE DES MATIÈRES

1. [Pré-requis Techniques](#1-pré-requis-techniques)
2. [Configuration App Store Connect](#2-configuration-app-store-connect)
3. [Assets Requis](#3-assets-requis)
4. [Textes Marketing](#4-textes-marketing)
5. [Documents Légaux](#5-documents-légaux)
6. [TestFlight Beta](#6-testflight-beta)
7. [Soumission App Store](#7-soumission-app-store)
8. [Après Soumission](#8-après-soumission)

---

## 1. PRÉ-REQUIS TECHNIQUES

### ✅ Checklist Code

- [ ] **Bundle ID unique** (ex: `com.tonnom.snapwake`)
- [ ] **Version number** (ex: `1.0.0`)
- [ ] **Build number** (ex: `1`)
- [ ] **App Icon** 1024x1024px (sans transparence, sans alpha)
- [ ] **Toutes les permissions** dans Info.plist avec descriptions claires
- [ ] **Pas de warnings critiques** dans Xcode
- [ ] **Build pour iOS 17.0+** minimum
- [ ] **Support iPhone ET iPad** (ou juste iPhone)

### Configuration Xcode

```
1. Ouvrir Xcode → Target SnapWake → General

2. Identity:
   - Display Name: SnapWake
   - Bundle Identifier: com.votrecompte.snapwake
   - Version: 1.0.0
   - Build: 1

3. Deployment Info:
   - Minimum Deployment: iOS 17.0 (ou 18.0 si tu utilises des features récentes)
   - iPhone ✓, iPad (optionnel)
   - Portrait orientation ✓

4. Signing & Capabilities:
   - Team: Votre équipe Apple Developer
   - Signing Certificate: Apple Distribution
   - Provisioning Profile: App Store (automatique)
```

### Apple Developer Account

**Requis:**
- [ ] Compte Apple Developer actif ($99/an)
- [ ] Certificat de distribution
- [ ] App Store provisioning profile

**Créer compte:**
```
1. https://developer.apple.com/programs/enroll/
2. S'inscrire (99€/an)
3. Attendre approbation (24-48h)
```

---

## 2. CONFIGURATION APP STORE CONNECT

### Créer l'App

**1. App Store Connect:**
```
https://appstoreconnect.apple.com
→ My Apps
→ + (Nouvelle App)
```

**2. Informations requises:**
```
- Platform: iOS
- Name: SnapWake
- Primary Language: Français (ou English)
- Bundle ID: com.votrecompte.snapwake (doit matcher Xcode)
- SKU: SNAPWAKE2025 (unique, pour tracking interne)
- User Access: Full Access
```

**3. Catégories (importantes pour discovery):**
```
Primary Category: Productivity
Secondary Category: Lifestyle

Age Rating:
- Fréquence violence/cartoon: None
- Fréquence contenu sexuel: None
- Fréquence langage grossier: None
- Fréquence drogue/alcool: None
→ Résultat: 4+
```

---

## 3. ASSETS REQUIS

### App Icon (OBLIGATOIRE)

**Format:**
- 1024x1024 pixels
- PNG ou JPEG
- Sans transparence (alpha channel)
- Sans coins arrondis (iOS les ajoute automatiquement)
- 72 DPI minimum

**Outil recommandé:**
- Figma, Sketch, ou Canva
- Template: https://www.figma.com/community/file/809151800300150544

**Où l'ajouter:**
```
Xcode → Assets.xcassets → AppIcon
Drag & drop image 1024x1024
```

### Screenshots (OBLIGATOIRE)

**Tailles requises:**

| Device | Résolution | Orientation |
|--------|-----------|-------------|
| iPhone 6.9" (16 Pro Max) | 1320 x 2868 | Portrait |
| iPhone 6.7" (14/15 Pro Max) | 1290 x 2796 | Portrait |
| iPhone 6.5" (11 Pro Max) | 1242 x 2688 | Portrait |
| iPhone 5.5" (8 Plus) | 1242 x 2208 | Portrait |

**Nombre de screenshots:**
- Minimum: 3 par taille
- Maximum: 10 par taille
- Recommandé: 5-6 screenshots bien choisis

**Quoi montrer:**
1. **Onboarding** - Première impression
2. **Alarm Setup** - Créer une alarme
3. **Mission en action** - Photo/Math/Exercise
4. **Success Screen** - Confetti celebration
5. **Stats/Streak** - Progrès utilisateur
6. **Social Features** (si Firebase activé)

**Outils pour créer screenshots:**
- Simulator → Capture (⌘+S)
- Design frames: https://www.figma.com/community/file/809151800300150544
- App Store Screenshot Generator: https://www.appscreens.com

### Preview Video (OPTIONNEL mais recommandé)

**Format:**
- Maximum 30 secondes
- 1080p ou 4K
- Format: .mov, .m4v, .mp4
- Tailles: Mêmes que screenshots

**Quoi montrer:**
```
0-3s: Logo + tagline "Wake up with purpose"
3-10s: Créer une alarme rapidement
10-20s: Mission en action (photo sky, math challenge)
20-25s: Success celebration
25-30s: Call to action "Download now"
```

---

## 4. TEXTES MARKETING

### App Name (30 caractères max)
```
SnapWake
OU
SnapWake - Smart Alarm
```

### Subtitle (30 caractères max)
```
Mission-Based Alarm Clock
OU
Wake Up with Challenges
```

### Promotional Text (170 caractères, modifiable sans review)
```
🔥 New: AI-powered photo verification!
Wake up by taking a photo of the sky, solving math, or doing push-ups.
Build your streak! 📈
```

### Description (4000 caractères max)

**Template optimisé SEO:**

```markdown
Wake up with PURPOSE. SnapWake is the intelligent alarm clock that makes you EARN your morning by completing real-world missions.

😴 TIRED OF SNOOZING?
SnapWake forces you out of bed with fun, engaging challenges that activate your brain and body.

⚡ 8 UNIQUE MISSIONS:
📸 Sky Photo - Take a photo of the sky to prove you're up
🛏️ Make Your Bed - Show your made bed
🔍 Object Hunt - Find random objects around your home
💪 Push-ups - Complete exercise challenges
📱 Shake Phone - Shake your phone to wake up
🧮 Math Challenge - Solve math problems
🗣️ Affirmation - Record positive affirmations
📖 Bible Verse - Read verses out loud

🤖 AI-POWERED VERIFICATION (FREE!)
Our advanced AI verifies your photos and voice recordings using Apple Vision & Speech Recognition. No cheating allowed!

🔥 BUILD YOUR STREAK
Track consecutive wake-up days and compete with friends. How long can you maintain your streak?

🎯 DIFFICULTY LEVELS
• Easy - Gentle wake-up
• Medium - Standard challenge
• Hard - Serious commitment
• Impossible - Ultimate willpower test

🎨 BEAUTIFUL DESIGN
Clean, modern interface with delightful animations and celebrations when you succeed.

🔊 7 ALARM SOUNDS
Choose from Air Raid Siren, Morning Birds, Ocean Waves, Rooster, and more!

🌟 PREMIUM FEATURES (Coming Soon)
• Revenge Alarms - Send wake-up challenges to friends
• Duo Alarms - Wake up together
• Global Leaderboard - Compete worldwide
• Detailed Statistics & Insights

💪 WHY SNAPWAKE WORKS
Traditional alarms let you hit snooze endlessly. SnapWake requires actual effort, activating your brain and body to ensure you're ACTUALLY awake.

🎓 PERFECT FOR:
• Students who struggle with morning classes
• Professionals who need reliable wake-ups
• Fitness enthusiasts building morning routines
• Anyone tired of oversleeping

🔐 PRIVACY FIRST
All photo/voice verification happens locally on your device. Your data is yours.

📱 REQUIREMENTS
• iOS 17.0 or later
• Camera access (for photo missions)
• Microphone access (for voice missions)

⭐ FREE TO USE
Core features are 100% free. Premium features optional.

Download SnapWake now and transform your mornings! 🌅

---

KEYWORDS: alarm, alarm clock, wake up, morning routine, challenge, mission, smart alarm, no snooze, productivity, habits, streak, photo alarm, math alarm, fitness alarm
```

### Keywords (100 caractères max, séparés par virgules)

```
alarm,wake up,morning,challenge,productivity,smart alarm,photo,math,fitness,habit,streak,mission
```

**Tips pour keywords:**
- Pas d'espaces après virgules
- Pas de mots répétés (App Store les combine automatiquement)
- Focus sur discovery (ce que les gens cherchent)

### What's New (4000 caractères, pour updates)

```
🎉 Welcome to SnapWake 1.0!

✨ NEW IN THIS VERSION:
• 8 unique wake-up missions
• AI-powered photo & voice verification
• Streak counter to track your progress
• Beautiful confetti celebrations
• 7 alarm sounds to choose from

🔜 COMING SOON:
• Revenge Alarms - Wake up your friends
• Duo Alarms - Wake up together
• Global Leaderboard
• Detailed statistics

Thank you for downloading SnapWake!
Rate us ⭐⭐⭐⭐⭐ if you love waking up with purpose!
```

---

## 5. DOCUMENTS LÉGAUX

### Privacy Policy (OBLIGATOIRE)

**Requis par Apple si l'app:**
- Collecte des données
- Utilise Firebase/Analytics
- A des achats in-app
- Se connecte à internet

**Template gratuit:**
```
https://www.privacypolicygenerator.info/
https://app-privacy-policy-generator.firebaseapp.com/
```

**Sections à inclure:**
```markdown
# Privacy Policy for SnapWake

Last updated: [DATE]

## Data Collection
SnapWake collects the following data:
- Email address (for account creation)
- Wake-up times and streak data
- Photo/audio recordings (processed locally, not stored)

## Data Usage
Your data is used to:
- Provide alarm and mission functionality
- Track your wake-up streak
- Sync data across devices (optional)

## Data Storage
- All photo/voice verification is processed locally on your device
- Streak data synced via Firebase (encrypted)
- We never sell your data to third parties

## Third-Party Services
- Firebase (Google) - Cloud sync
- RevenueCat - Payment processing

## Your Rights
You can request data deletion at any time by contacting support@snapwake.com

## Contact
Email: support@snapwake.com
```

**Où héberger:**
- GitHub Pages (gratuit)
- Firebase Hosting (gratuit)
- Ton propre site web

**URL à fournir dans App Store Connect:**
```
https://votre-site.com/privacy-policy
```

### Terms of Service (RECOMMANDÉ)

**Template:**
```markdown
# Terms of Service for SnapWake

## Acceptance of Terms
By using SnapWake, you agree to these terms.

## Use License
SnapWake grants you a non-transferable license to use the app for personal use.

## Prohibited Uses
You may not:
- Use the app for illegal purposes
- Attempt to reverse-engineer the app
- Abuse the social features (spam, harassment)

## Disclaimer
SnapWake is not responsible for:
- Missed wake-ups due to device issues
- Injuries from exercise missions (use caution)

## Subscription Terms (if Premium)
- Auto-renewal monthly/yearly
- Cancel anytime in Settings
- No refunds for partial periods

## Changes to Terms
We may update these terms at any time.

## Contact
support@snapwake.com
```

### Support URL (OBLIGATOIRE)

**Options:**
```
1. Email: support@snapwake.com
2. Website: https://snapwake.com/support
3. FAQ page
4. Discord/Community (si tu en as un)
```

**Minimum acceptable:**
- Page simple avec email de contact
- FAQ basique (5-10 questions)

---

## 6. TESTFLIGHT BETA

### Pourquoi faire un Beta?

✅ **Avantages:**
- Tester avec de vrais utilisateurs
- Identifier bugs avant l'App Store
- Obtenir feedback early
- Build confiance avec early adopters
- Pas de review Apple (instant deployment)

### Setup TestFlight

**1. Archive l'app:**
```
Xcode → Product → Archive
→ Attendre compilation
→ Window: Organizer s'ouvre
```

**2. Upload vers App Store Connect:**
```
Organizer → Distribute App
→ App Store Connect
→ Upload
→ Attendre processing (10-30 min)
```

**3. Ajouter testeurs:**
```
App Store Connect → TestFlight
→ Internal Testing (jusqu'à 100 personnes de ton équipe)
OU
→ External Testing (jusqu'à 10,000 personnes externes)
```

**4. Inviter beta testeurs:**
```
Email ou lien public:
https://testflight.apple.com/join/VOTRE_CODE
```

### Beta Testing Checklist

**Tester pendant 1-2 semaines:**

- [ ] Créer/éditer alarmes
- [ ] Tester toutes les 8 missions
- [ ] Vérifier AI verification
- [ ] Tester voice recording
- [ ] Vérifier sounds
- [ ] Tester sur différents iPhones (SE, 14, 15, 16)
- [ ] Tester sur iOS 17 ET iOS 18
- [ ] Vérifier en dark mode
- [ ] Tester avec faible batterie
- [ ] Tester sans internet (offline)

**Collecter feedback:**
- Crashes/bugs
- Features manquantes
- UX improvements
- Performance issues

---

## 7. SOUMISSION APP STORE

### Dernières Vérifications

**1. Info.plist Permissions:**
```xml
<key>NSCameraUsageDescription</key>
<string>SnapWake needs camera access to verify photo missions like Sky Photo and Make Bed.</string>

<key>NSMicrophoneUsageDescription</key>
<string>SnapWake needs microphone access to record your affirmations and Bible verses.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>SnapWake uses speech recognition to verify you read affirmations and verses out loud.</string>

<key>NSMotionUsageDescription</key>
<string>SnapWake needs motion sensor access for the Shake Phone mission.</string>
```

**2. App Store Connect - Version Information:**

```
Version: 1.0.0

Copyright: 2025 Votre Nom ou Entreprise

Age Rating: 4+

Price: Free (avec achats in-app optionnels si Premium)

Availability:
- Tous les pays OU
- Pays spécifiques (US, Canada, France, etc.)
```

**3. App Review Information:**

```
Contact Information:
- First Name: [Votre prénom]
- Last Name: [Votre nom]
- Phone: +33 X XX XX XX XX
- Email: support@snapwake.com

Demo Account (si needed):
- Username: demo@snapwake.com
- Password: Demo123456!
- Notes: "This is a test account with pre-configured alarms"
```

**4. Notes pour Review:**

```
SnapWake is an alarm clock app that uses missions to ensure users wake up.

IMPORTANT FOR REVIEWERS:
1. Grant all permissions (Camera, Microphone, Motion, Speech)
2. Create an alarm for 1-2 minutes in the future
3. When alarm rings, complete any mission to test:
   - Sky Photo: Point camera at ceiling/light
   - Make Bed: Point camera at any bed/sofa
   - Math Challenge: Solve simple math
   - Affirmation: Record any voice message

AI verification uses Apple Vision & Speech frameworks (free, offline).
No external APIs or paid services required.

Test account provided for convenience, but app works without login.
```

### Submit for Review

**1. Dans App Store Connect:**
```
Your App → 1.0 Prepare for Submission

Complete tous les champs:
✓ Screenshots (5-6 par taille)
✓ Preview Video (optionnel)
✓ Description
✓ Keywords
✓ Support URL
✓ Privacy Policy URL
✓ Age Rating: 4+
✓ App Review Information
```

**2. Export Compliance:**
```
"Does your app use encryption?"
→ Sélectionner: No (ou Yes si tu utilises HTTPS)

Si Yes:
→ "Does your app qualify for exemption?"
→ Yes (pour HTTPS standard)
```

**3. Pricing:**
```
Free (avec possibilité achats in-app si Premium)

OU

Premium dès le départ:
- $0.99/mois
- $9.99/an (économie 17%)
```

**4. Submit:**
```
Bouton: "Submit for Review"
→ Confirmation
→ Status: "Waiting for Review"
```

---

## 8. APRÈS SOUMISSION

### Timeline Attendu

```
Submit → Waiting for Review (24-72h)
       → In Review (12-48h)
       → Pending Developer Release OU Rejected
```

**Temps moyen:** 1-3 jours ouvrés

### Si Approuvé ✅

**1. Status: "Pending Developer Release"**
```
Options:
- Release Automatically (dès approbation)
- Manually Release (tu choisis quand)
```

**2. Une fois Released:**
```
Status: "Ready for Sale"
→ App visible sur App Store en ~1-2 heures
```

**3. Lien App Store:**
```
https://apps.apple.com/app/idXXXXXXXXXX

Share ce lien pour downloads!
```

### Si Rejeté ❌

**Raisons communes:**
1. **Crash pendant review**
   - Fix le bug
   - Upload nouvelle build
   - Re-submit

2. **Permissions non expliquées**
   - Améliorer descriptions dans Info.plist
   - Expliquer dans Notes for Review

3. **Contenu manquant**
   - Ajouter screenshots manquants
   - Privacy Policy URL invalide

4. **Guideline violation**
   - Lire le feedback Apple
   - Adapter l'app
   - Ré-expliquer dans Notes

**Process après rejet:**
```
1. Lire message de rejet dans Resolution Center
2. Fix les problèmes mentionnés
3. Répondre dans Resolution Center (expliquer changes)
4. Re-submit
→ Review plus rapide (généralement <24h)
```

---

## 📱 CHECKLIST FINALE

### Avant Submit

- [ ] Bundle ID configuré et unique
- [ ] Version 1.0.0, Build 1
- [ ] App Icon 1024x1024 ajouté
- [ ] Toutes permissions Info.plist avec descriptions
- [ ] Testé sur iPhone réel (pas seulement simulateur)
- [ ] Testé toutes les missions
- [ ] Pas de crashes ni bugs majeurs
- [ ] TestFlight beta fait (recommandé)
- [ ] Screenshots créés (5-6 par taille)
- [ ] Description App Store rédigée
- [ ] Privacy Policy URL active
- [ ] Support URL active
- [ ] Apple Developer account actif ($99 payé)

### Assets App Store Connect

- [ ] Screenshots 6.9" (5-6)
- [ ] Screenshots 6.5" (5-6)
- [ ] Preview video (optionnel)
- [ ] App Icon 1024x1024
- [ ] Description (optimisée SEO)
- [ ] Keywords (100 char)
- [ ] Promotional text
- [ ] What's New text
- [ ] Privacy Policy URL
- [ ] Support URL
- [ ] Contact info pour review
- [ ] Notes pour reviewers

### Post-Launch

- [ ] Monitor crashes (Xcode Organizer)
- [ ] Répondre aux reviews (surtout négatifs)
- [ ] Créer landing page web
- [ ] Partager sur réseaux sociaux
- [ ] Product Hunt launch (optionnel)
- [ ] Email early testers
- [ ] Demander reviews aux early users

---

## 💰 MONÉTIZATION OPTIONS

### Free with Premium (Recommandé pour débuter)

**Free tier:**
- Toutes les missions
- Streak tracking
- 7 alarm sounds
- Illimité

**Premium ($2.99/mois ou $19.99/an):**
- Revenge Alarms
- Duo Alarms
- Global Leaderboard
- Detailed stats
- Custom alarm sounds
- Priority support

**Setup:**
- RevenueCat (gratuit jusqu'à $2,500 MRR)
- StoreKit 2 (natif Apple)

### Paid App

**Prix suggéré:**
- $0.99 - Entry level
- $2.99 - Standard
- $4.99 - Premium positioning

**Avantages:**
- Revenue immédiat
- Pas de IAP complexity

**Désavantages:**
- Moins de downloads
- Plus dur de scale

### Freemium Ads

**Pas recommandé** pour SnapWake car:
- Mauvaise UX pour alarmes
- Revenue faible (<$0.01/user/day)
- Distraction le matin

---

## 🚀 MARKETING POST-LAUNCH

### Week 1

**Jour 1-3:**
- [ ] Share sur tes réseaux personnels
- [ ] Post LinkedIn/Twitter/Instagram
- [ ] Email early beta testers
- [ ] Demander reviews 5⭐

**Jour 4-7:**
- [ ] Product Hunt launch
- [ ] Reddit (r/productivity, r/getdisciplined)
- [ ] TikTok/Reels demo videos
- [ ] Blog post ou article

### Week 2-4

- [ ] Contacter tech blogs/YouTubers
- [ ] Press kit (screenshots, description, logo)
- [ ] A/B test screenshots App Store
- [ ] Monitor keywords ranking (App Store SEO)

### Ongoing

- [ ] Update réguliers (1x/mois minimum)
- [ ] Répondre tous les reviews
- [ ] Build community (Discord/subreddit)
- [ ] Écouter feedback users
- [ ] Itérer features

---

## 📊 MÉTRIQUES À SUIVRE

### App Store Connect Analytics

- **Downloads** (installs quotidiens)
- **Conversion rate** (page views → downloads)
- **Crashes** (doit être <1%)
- **Rating** (viser 4.5+/5)
- **Revenue** (si Premium/IAP)

### Firebase Analytics (si configuré)

- **Daily Active Users (DAU)**
- **Retention** (Day 1, Day 7, Day 30)
- **Wake-up completion rate**
- **Mission success rate**
- **Streak distribution**

### Business Metrics

- **User acquisition cost (UAC)**
- **Lifetime value (LTV)**
- **Churn rate**
- **Monthly recurring revenue (MRR)**

---

## ⚡ QUICK ACTIONS

### Aujourd'hui (2-3 heures)

1. **Fix Bundle ID Firebase** (si pas déjà fait)
2. **Créer App Icon 1024x1024**
   - Canva/Figma
   - Couleurs SnapWake (orange #FF6F00)
   - Logo clair et simple
3. **Prendre 6 screenshots** (simulateur iPhone 16 Pro Max)
   - Onboarding welcome
   - Alarm creation
   - Sky photo mission
   - Math challenge
   - Success confetti
   - Streak counter

### Cette semaine (5-10 heures)

4. **Rédiger textes marketing**
   - Description App Store
   - Keywords
   - Privacy Policy (template)
5. **Créer compte Apple Developer** ($99)
6. **TestFlight beta** avec 5-10 amis
7. **Fix bugs identifiés**

### Semaine prochaine (3-5 heures)

8. **Créer App Store Connect listing**
9. **Upload screenshots + textes**
10. **Submit for Review**
11. **Attendre approbation** (1-3 jours)

**Timeline total: 2-3 semaines** de la décision au launch! 🚀

---

## 🆘 AIDE & RESOURCES

### Documentation Apple

- **App Store Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/
- **App Store Connect Help**: https://help.apple.com/app-store-connect/

### Outils Utiles

- **Screenshot Generator**: https://www.appscreens.com
- **Icon Generator**: https://appicon.co
- **Privacy Policy**: https://app-privacy-policy-generator.firebaseapp.com/
- **ASO (App Store Optimization)**: https://www.apptweakcom
- **Keywords Research**: https://searchads.apple.com

### Communities

- **r/iOSProgramming** - Aide technique
- **r/AppBusiness** - Business/marketing
- **Indie Hackers** - Entrepreneurs indie
- **Twitter #buildinpublic** - Partager progress

---

## ✅ TU ES PRÊT!

L'app est **techniquement prête**. Il ne reste que:

1. **Assets** (icon, screenshots) - 2-3h
2. **Textes** (description, privacy) - 1-2h
3. **Apple Developer** ($99) - 10 min
4. **App Store Connect** setup - 1h
5. **Submit** - 5 min

**Total: ~1 journée de travail** pour aller du code actuel → App Store! 🎉

Besoin d'aide sur une étape spécifique? Dis-moi! 🚀
