//
//  SimpleInfoView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct SimpleInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    let title: String
    let icon: String
    let iconColor: Color
    let content: String

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 32)

                    Spacer()

                    // Icon
                    ZStack {
                        Circle()
                            .fill(iconColor.opacity(0.2))
                            .frame(width: 100, height: 100)

                        Image(systemName: icon)
                            .font(.system(size: 50))
                            .foregroundColor(iconColor)
                    }

                    // Title
                    Text(title)
                        .font(.faroBold(size: 32))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .multilineTextAlignment(.center)

                    // Content
                    Text(content)
                        .font(.faro(size: 16))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer()
                }
                .padding(.vertical, 40)
            }
        }
    }
}

#Preview {
    SimpleInfoView(
        title: "Troubleshooting",
        icon: "exclamationmark.triangle.fill",
        iconColor: .orange,
        content: "If your alarm isn't working, make sure:\n\n1. Notifications are enabled\n2. App has critical alerts permission\n3. Your device isn't in silent mode\n4. The alarm is turned on"
    )
}
