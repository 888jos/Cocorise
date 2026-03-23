//
//  MascotView.swift
//  SnapWake
//
//  Created by Claude on 20/03/2026.
//

import SwiftUI

/// Composant réutilisable pour afficher une mascotte statique de manière sobre et premium
struct MascotView: View {
    let mascot: MascotAsset
    let size: MascotSize
    let alignment: HorizontalAlignment
    let withShadow: Bool

    init(
        _ mascot: MascotAsset,
        size: MascotSize = .medium,
        alignment: HorizontalAlignment = .center,
        withShadow: Bool = false
    ) {
        self.mascot = mascot
        self.size = size
        self.alignment = alignment
        self.withShadow = withShadow
    }

    var body: some View {
        mascot.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.dimension, height: size.dimension)
            .shadow(
                color: withShadow ? Color.black.opacity(0.08) : Color.clear,
                radius: withShadow ? 12 : 0,
                y: withShadow ? 6 : 0
            )
            .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : (alignment == .trailing ? .trailing : .center))
    }
}

/// Tailles prédéfinies pour les mascottes
enum MascotSize {
    case small
    case medium
    case large

    var dimension: CGFloat {
        switch self {
        case .small: return 140
        case .medium: return 200
        case .large: return 280
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 32) {
        MascotView(.bienvenue, size: .small)
        MascotView(.guide, size: .medium, withShadow: true)
        MascotView(.victoire, size: .large)
    }
    .padding()
}
