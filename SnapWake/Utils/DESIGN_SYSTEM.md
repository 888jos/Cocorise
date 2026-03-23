# SnapWake Design System

## 🎨 Brand Colors

### Primary Colors
- **Orange** (`snapOrange`) - Primary action color, CTAs, highlights
- **Pink** (`snapPink`) - Secondary accent, gradients
- **Green** (`snapGreen`) - Success states, completions
- **Blue** (`snapBlue`) - Information, icons

### Neutral Colors
- **Text Primary** (`snapTextPrimary`) - Main text (adapts to dark/light mode)
- **Text Secondary** (`snapTextSecondary`) - Secondary text, hints
- **Background** (`snapBackground`) - App background
- **Card** (`snapCard`) - Card/container backgrounds
- **Card Secondary** (`snapCardSecondary`) - Nested containers

## 📝 Typography

### Font Family
- **Faro** - Custom brand font
  - `faro(size:)` - Regular weight
  - `faroSemiBold(size:)` - Medium weight
  - `faroBold(size:)` - Bold weight

### Font Sizes (DesignSystem.FontSize)
```swift
.caption         // 13pt - Small labels, metadata
.body            // 15pt - Standard body text
.bodyLarge       // 17pt - Emphasized body text
.title3          // 20pt - Small headers
.title2          // 22pt - Medium headers
.title1          // 24pt - Large headers
.largeTitle      // 28pt - Page titles
.display         // 48pt - Extra large displays
.displayLarge    // 56pt - Alarm times
.displayHuge     // 60pt - Pickers, counters
```

### Usage Examples
```swift
Text("Welcome")
    .font(.faroBold(size: DesignSystem.FontSize.title1))

Text("Description text")
    .font(.faro(size: DesignSystem.FontSize.body))
```

## 🔘 Buttons

### Primary Button
Orange gradient, white text, for main CTAs
```swift
Button("Continue") {
    // action
}
.snapPrimaryButton()

// With disabled state
.snapPrimaryButton(isEnabled: isValid)
```

### Secondary Button
Card background, primary text color, for secondary actions
```swift
Button("Cancel") {
    // action
}
.snapSecondaryButton()
```

## 📐 Spacing (DesignSystem.Spacing)
```swift
.tiny          // 4pt
.small         // 8pt
.medium        // 12pt
.large         // 16pt
.extraLarge    // 20pt
.xxLarge       // 24pt
.xxxLarge      // 32pt
```

## 🔄 Corner Radius (DesignSystem.CornerRadius)
```swift
.small         // 8pt  - Small elements
.medium        // 12pt - Cards, containers
.large         // 16pt - Buttons, modals
.extraLarge    // 20pt - Large cards
.pill          // 30pt - Pill-shaped elements
```

## 🎯 Icon Sizes (DesignSystem.IconSize)
```swift
.small         // 14pt - Small UI icons
.medium        // 20pt - Standard icons
.large         // 24pt - Header icons
.extraLarge    // 28pt - Featured icons
.huge          // 50pt - Picker controls
```

## 📦 Components

### SnapCard
Reusable card container with consistent styling
```swift
SnapCard {
    VStack {
        Text("Content")
    }
}

// Custom corner radius and padding
SnapCard(cornerRadius: DesignSystem.CornerRadius.large,
         padding: DesignSystem.Spacing.extraLarge) {
    // content
}
```

### SnapSectionHeader
Consistent section headers with optional action
```swift
SnapSectionHeader(title: "Recent Activity")

// With action button
SnapSectionHeader(
    title: "Alarms",
    action: { showAll() },
    actionTitle: "See All"
)
```

### SnapIconBadge
Consistent icon styling
```swift
SnapIconBadge(icon: "alarm.fill")
SnapIconBadge(icon: "flame.fill", color: .snapOrange, size: 28)
```

### SnapGradientBackground
Brand gradient backgrounds
```swift
SnapGradientBackground() // Default orange to pink

SnapGradientBackground(
    colors: [.blue, .purple],
    startPoint: .top,
    endPoint: .bottom
)
```

## 🎬 Animations

### Standard Duration
- **Quick**: 0.2s - Small UI changes
- **Standard**: 0.3s - Default transitions
- **Slow**: 0.5s - Page transitions

### Standard Easing
```swift
.animation(.easeInOut, value: someValue)
.animation(.spring(response: 0.3, dampingFraction: 0.7), value: someValue)
```

## ✅ Best Practices

1. **Always use Faro fonts** - Never use `.system()` for visible text
2. **Use design constants** - Don't hardcode sizes, use `DesignSystem.*`
3. **Consistent spacing** - Use standard spacing values
4. **Brand colors** - Use `snap*` colors for consistency
5. **Reuse components** - Prefer `SnapCard`, `SnapSectionHeader` over custom implementations
6. **Button styles** - Use `.snapPrimaryButton()` and `.snapSecondaryButton()`
7. **Corner radius** - Use standard values (8, 12, 16, 20, 30)

## 🚫 Anti-Patterns

❌ Don't:
```swift
.font(.system(size: 17, weight: .semibold))
.cornerRadius(15)
.padding(18)
.background(Color(hex: "#FF5733"))
```

✅ Do:
```swift
.font(.faroSemiBold(size: DesignSystem.FontSize.bodyLarge))
.cornerRadius(DesignSystem.CornerRadius.large)
.padding(DesignSystem.Spacing.large)
.background(Color.snapOrange)
```
