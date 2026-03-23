# Poppins Bold Font Setup

## ✅ What's Already Done

All onboarding titles have been updated to use Poppins Bold:
- `NewOnboardingView.swift` - ✅ 5 titles updated
- `OnboardingView.swift` - ✅ 1 title updated
- `CompleteOnboardingView.swift` - ✅ 71 titles updated

Font extension created with `.poppinsBold(size:)` helper in `Utils/FontExtension.swift`

## 📥 Download Poppins Bold Font

1. Go to Google Fonts: https://fonts.google.com/specimen/Poppins
2. Click "Get font" then "Download all"
3. Extract the ZIP file
4. Locate `Poppins-Bold.ttf` in the `static` folder

## 🔧 Add to Xcode Project

### Step 1: Add Font File

1. Download `Poppins-Bold.ttf`
2. In Xcode, right-click on `Resources/Fonts` folder
3. Select "Add Files to SnapWake..."
4. Choose `Poppins-Bold.ttf`
5. **Important**: Check these options:
   - ✅ "Copy items if needed"
   - ✅ "Create groups"
   - ✅ Add to target: "SnapWake"

### Step 2: Register in Info.plist

1. Select your project → SnapWake target → Info tab
2. Find "Fonts provided by application" (or add it if missing)
3. Add a new item: `Poppins-Bold.ttf`

Or edit Info.plist as source code and ensure you have:

```xml
<key>UIAppFonts</key>
<array>
    <string>Faro-Regular.ttf</string>
    <string>Faro-SemiBold.ttf</string>
    <string>Faro-Bold.ttf</string>
    <string>Poppins-Bold.ttf</string>
</array>
```

### Step 3: Verify Target Membership

1. Select `Poppins-Bold.ttf` in Project Navigator
2. Check File Inspector (right sidebar)
3. Ensure "SnapWake" is checked under Target Membership

### Step 4: Build and Test

1. Clean: `Cmd + Shift + K`
2. Build: `Cmd + B`
3. Run: `Cmd + R`
4. Check console for: `✅ Font loaded: Poppins-Bold`

## ✅ Current Font Usage

### Titles (Poppins Bold)
All major titles in onboarding now use:
```swift
Text("My Title")
    .font(.poppinsBold(size: 34))
```

### Body Text (Faro)
Regular text still uses Faro:
```swift
Text("Description")
    .font(.faro(size: 16))
```

### Buttons (Faro Bold)
Button text uses Faro Bold (< 24pt):
```swift
Text("Continue")
    .font(.faroBold(size: 18))
```

## 🎨 Font Hierarchy

- **Poppins Bold** (20-80pt) → Main titles, headlines
- **Faro Bold** (16-20pt) → Buttons, small headings
- **Faro SemiBold** (14-18pt) → Subheadings
- **Faro Regular** (12-18pt) → Body text, descriptions

## 🐛 Troubleshooting

If Poppins doesn't load:
1. Check the font file name is exactly `Poppins-Bold.ttf`
2. Verify it's in Info.plist under UIAppFonts
3. Check Build Phases → Copy Bundle Resources
4. Clean and rebuild
5. Use `FontLoader.printAvailableFonts()` to debug

## 📝 File Locations

- Font file: `/Users/jos/SnapWake/SnapWake/Resources/Fonts/Poppins-Bold.ttf`
- Extension: `/Users/jos/SnapWake/SnapWake/Utils/FontExtension.swift`
- Loader: FontLoader.loadCustomFonts() in SnapWakeApp.swift
