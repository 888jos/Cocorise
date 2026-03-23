//
//  FontExtension.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

extension Font {
    // Faro Regular
    static func faro(size: CGFloat) -> Font {
        return .custom("Faro-Regular", size: size)
    }

    // Faro SemiBold
    static func faroSemiBold(size: CGFloat) -> Font {
        return .custom("Faro-SemiBold", size: size)
    }

    // Faro Bold
    static func faroBold(size: CGFloat) -> Font {
        return .custom("Faro-Bold", size: size)
    }

    // Poppins Bold (for titles)
    static func poppinsBold(size: CGFloat) -> Font {
        return .custom("Poppins-Bold", size: size)
    }
}

// Helper pour vérifier que les polices sont bien chargées
class FontLoader {
    static func loadCustomFonts() {
        let fontNames = ["Faro-Regular", "Faro-SemiBold", "Faro-Bold", "Poppins-Bold"]

        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf"),
               let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
               let font = CGFont(fontDataProvider) {
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    print("Error loading font \(fontName): \(error.debugDescription)")
                } else {
                    print("✅ Font loaded: \(fontName)")
                }
            } else {
                print("❌ Font file not found: \(fontName)")
            }
        }
    }

    static func printAvailableFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) - Fonts: \(names)")
        }
    }
}
