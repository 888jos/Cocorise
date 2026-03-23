# Onboarding V2 - Chat Style with Coco 🐓

## ✅ What's New

A brand new onboarding experience designed as a chat conversation with Coco, the morning mascot!

### Key Features

1. **Chat-Style Interface** 📱
   - Message bubbles (like iMessage/WhatsApp)
   - Coco's messages on the left (white bubbles)
   - User responses on the right (orange bubbles)

2. **Coco Mascot Integration** 🐓
   - Different mascot expressions for different messages
   - Available mascots:
     - `mascot_bienvenue` - Welcome/greeting
     - `mascot_guide` - Guiding/asking questions
     - `mascot_challenge` - Challenging/motivating
     - `mascot_encouragement` - Encouraging
     - `mascot_victoire` - Victory/celebration
     - `mascot_triste` - Sad/empathetic

3. **Typing Indicator** ⌛
   - Animated dots showing Coco is "typing"
   - Creates natural conversation flow

4. **Interactive Responses** 💬
   - Text input for open questions (name, dreams)
   - Quick reply buttons for choices (snooze time, commitment)
   - Auto-scroll to latest message

## 📝 Conversation Flow

```
1. Coco: "Hey! 👋"
2. Coco: "I'm Coco, your morning coach!"
3. Coco: "I'm here to help you become a morning person ☀️"
4. Coco: "What's your name?"
5. User: [Types their name]
6. Coco: "Nice to meet you, {name}! 🎉"
7. Coco: "Let me ask you something..."
8. Coco: "How long do you spend hitting snooze each morning?"
9. User: [Selects option: "Under 10 min", "10-20 min", etc.]
10. Coco: "I see... 🤔"
11. Coco: "That's time you could be using for yourself!"
12. Coco: "Imagine waking up energized, ready to win the day 💪"
13. Coco: "What's your biggest dream right now?"
14. Coco: "What could you achieve if you mastered your mornings?"
15. User: [Types their dream]
16. Coco: "That's amazing! ✨"
17. Coco: "I'm going to help you make that happen."
18. Coco: "Are you ready to commit to becoming a morning person?"
19. User: [Selects: "I'm determined! 🔥", "Let's do this 💪", etc.]
20. Coco: "That's the spirit! 🎯"
21. Coco: "Let's build your personalized morning plan together!"
22. → Finish onboarding
```

## 🎨 UI Components

### MessageBubble
- Displays messages from Coco or user
- Coco's messages: white background, left-aligned, with mascot avatar
- User's messages: orange background, right-aligned
- Rounded corners with small tail on bottom corner

### TypingIndicator
- Three animated dots
- Shows while waiting for next Coco message
- White bubble on left side with mascot avatar

### InputArea
- Two modes:
  1. **Text Input**: TextField with send button
  2. **Quick Replies**: Horizontal scrolling buttons

## 🔄 How to Switch Between Onboarding Versions

### Use V2 (Chat Style - Current)
In `ContentView.swift` line 22:
```swift
OnboardingV2View(isComplete: $onboardingComplete)
```

### Use V1 (Original Complete Version)
```swift
CompleteOnboardingView(isComplete: $onboardingComplete)
```

### Use Simple Version
```swift
OnboardingView(isComplete: $onboardingComplete)
```

### Use NewOnboarding Version
```swift
NewOnboardingView(isComplete: $onboardingComplete)
```

## 📂 File Structure

```
Views/Onboarding/
├── OnboardingV2View.swift      ← NEW! Chat-style onboarding
├── CompleteOnboardingView.swift ← Original full onboarding
├── OnboardingView.swift         ← Simple slide-based
└── NewOnboardingView.swift      ← Sunrise animation version
```

## 🎯 Data Collected

The chat onboarding collects:
- `userName` - User's first name
- `selectedSnoozeTime` - How long they snooze
- `biggestDream` - Their biggest goal/dream
- `commitment` - Their commitment level

All saved to UserDefaults when onboarding completes.

## 🚀 Next Steps

To fully integrate with missions and alarms, you could extend this to ask:
- Preferred wake time
- Mission selection
- Days of the week
- Alarm sound preference

Just add more steps to the `conversationFlow` array!

## 💡 Customization Tips

### Add New Questions
```swift
.cocoMessage("Your question here?", mascot: "mascot_guide"),
.userInput(.newType),  // Add to InputType enum
```

### Add New Choices
```swift
.userChoice(.newChoice, options: ["Option 1", "Option 2", "Option 3"]),
```

### Change Mascot Expressions
Just change the mascot parameter:
```swift
.cocoMessage("Great job!", mascot: "mascot_victoire")
```

### Adjust Timing
Change delays in `showNextMessage()`:
```swift
DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change 1.0
    // ...
}
```

## 🐛 Troubleshooting

### Mascot images not showing
- Make sure mascot images exist in Assets.xcassets/Mascots/
- Check image names match exactly (case-sensitive)

### Messages not auto-scrolling
- Check ScrollViewReader is working
- Verify message IDs are unique

### Typing indicator stuck
- Make sure `showTypingIndicator = false` is called
- Check timing delays aren't conflicting

## ✨ Features

- ✅ Natural conversation flow
- ✅ Typing indicator animation
- ✅ Auto-scroll to latest message
- ✅ Smooth transitions between messages
- ✅ Mascot avatar with different expressions
- ✅ Text and quick reply inputs
- ✅ Personalized with user's name
- ✅ Saves user data to UserDefaults
- ✅ Requests notification permission at end
