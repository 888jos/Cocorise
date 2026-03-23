//
//  MissionBrandingView.swift
//  SnapWake
//
//  Branding component for mission views - marketing visibility
//

import SwiftUI

struct MissionBrandingView: View {
    var body: some View {
        HStack(spacing: 6) {
            Text("COCORISE")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .tracking(1.5)

            Circle()
                .fill(Color.snapOrange)
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.6))
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.3), radius: 8, y: 2)
    }
}

#Preview {
    ZStack {
        Color.black
        MissionBrandingView()
    }
}
