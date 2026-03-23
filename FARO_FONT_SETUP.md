# Faro Font Integration Guide

## ✅ What's Already Done

1. **Font Files**: The Faro font files are already in place:
   - `SnapWake/Resources/Fonts/Faro-Regular.ttf`
   - `SnapWake/Resources/Fonts/Faro-SemiBold.ttf`
   - `SnapWake/Resources/Fonts/Faro-Bold.ttf`

2. **Font Extension**: Custom font helpers are already created in `Utils/FontExtension.swift`
   - `.faro(size:)` for regular weight
   - `.faroSemiBold(size:)` for semi-bold weight
   - `.faroBold(size:)` for bold weight

3. **Font Loading**: Fonts are automatically loaded on app startup in `SnapWakeApp.swift`

## 🔧 Steps to Complete in Xcode

### Step 1: Add Fonts to Xcode Project

1. Open Xcode and your project
2. In the Project Navigator (left sidebar), right-click on the `Resources/Fonts` folder
3. Select "Add Files to SnapWake..."
4. Navigate to `SnapWake/Resources/Fonts/`
5. Select all three Faro font files:
   - Faro-Regular.ttf
   - Faro-SemiBold.ttf
   - Faro-Bold.ttf
6. **Important**: Check these options:
   - ✅ "Copy items if needed"
   - ✅ "Create groups" (not "Create folder references")
   - ✅ Add to target: "SnapWake"
7. Click "Add"

### Step 2: Register Fonts in Info.plist

1. In Xcode, select your project in the Project Navigator
2. Select the "SnapWake" target
3. Go to the "Info" tab
4. Click the "+" button to add a new key
5. Type "Fonts provided by application" or "UIAppFonts"
6. Expand the array and add 3 items:
   - Item 0: `Faro-Regular.ttf`
   - Item 1: `Faro-SemiBold.ttf`
   - Item 2: `Faro-Bold.ttf`

Alternatively, if you prefer editing the Info.plist as source code:
- Right-click on Info.plist → "Open As" → "Source Code"
- Add this before the closing `</dict>`:

```xml
<key>UIAppFonts</key>
<array>
    <string>Faro-Regular.ttf</string>
    <string>Faro-SemiBold.ttf</string>
    <string>Faro-Bold.ttf</string>
</array>
```

### Step 3: Verify Font Files Are in Target

1. Select each font file in the Project Navigator
2. Open the File Inspector (right sidebar)
3. Under "Target Membership", ensure "SnapWake" is checked ✅

### Step 4: Build and Test

1. Clean Build Folder: `Cmd + Shift + K`
2. Build the project: `Cmd + B`
3. Run the app: `Cmd + R`
4. Check the console for font loading messages:
   - ✅ "Font loaded: Faro-Regular"
   - ✅ "Font loaded: Faro-SemiBold"
   - ✅ "Font loaded: Faro-Bold"

## 🐛 Troubleshooting

### Fonts not loading?

1. **Check file names match exactly**:
   - File names in Finder should match names in Info.plist
   - Font names are case-sensitive

2. **Verify font files are copied to the app bundle**:
   - Run the app in Simulator
   - Check the app bundle: The font files should be in the .app package

3. **Print available fonts**:
   Add this to `SnapWakeApp.init()` temporarily:
   ```swift
   FontLoader.printAvailableFonts()
   ```
   Look for "Faro" in the console output

4. **Check Build Phases**:
   - Project → Target → Build Phases → "Copy Bundle Resources"
   - All three .ttf files should be listed there

## 📝 Usage Examples

Once integrated, use the fonts like this:

```swift
// Regular
Text("Hello World")
    .font(.faro(size: 16))

// Semi-Bold
Text("Hello World")
    .font(.faroSemiBold(size: 18))

// Bold
Text("Hello World")
    .font(.faroBold(size: 20))
```

## ✨ Already Using Faro Fonts

The following files are already using Faro fonts:
- `Views/Onboarding/CompleteOnboardingView.swift`
- `Views/Onboarding/OnboardingView.swift`
- Many other UI components

Once you complete the Xcode setup above, these fonts will display correctly!
