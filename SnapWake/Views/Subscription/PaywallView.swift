//
//  PaywallView.swift
//  SnapWake
//
//  RevenueCat Paywall
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var revenueCatManager = RevenueCatManager.shared

    var body: some View {
        PaywallView(offering: revenueCatManager.offerings?.current)
            .onRestoreCompleted { customerInfo in
                print("✅ Restore completed")
                if customerInfo.entitlements["Cocorise Pro"]?.isActive == true {
                    dismiss()
                }
            }
            .onPurchaseCompleted { customerInfo in
                print("✅ Purchase completed")
                if customerInfo.entitlements["Cocorise Pro"]?.isActive == true {
                    dismiss()
                }
            }
            .onPurchaseFailure { error in
                print("❌ Purchase failed: \(error.localizedDescription)")
            }
    }
}

// Alternative custom paywall if you prefer more control
struct CustomPaywallView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var revenueCatManager = RevenueCatManager.shared

    @State private var selectedPackage: Package?
    @State private var isPurchasing = false
    @State private var showingError = false
    @State private var errorMessage = ""

    var monthlyPackage: Package? {
        revenueCatManager.offerings?.current?.monthly
    }

    var yearlyPackage: Package? {
        revenueCatManager.offerings?.current?.annual
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.snapBackground(for: colorScheme)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)

                            Text("Cocorise Pro")
                                .font(.system(size: 36, weight: .bold, design: .rounded))

                            Text("Unlock all premium features")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 24)

                        // Features
                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(icon: "infinity", title: "Unlimited Alarms", description: "Create as many alarms as you need")
                            FeatureRow(icon: "star.fill", title: "All Missions Unlocked", description: "Access every wake-up mission")
                            FeatureRow(icon: "trophy.fill", title: "Advanced Leagues", description: "Compete in premium leagues")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Detailed Analytics", description: "Deep insights into your habits")
                            FeatureRow(icon: "bell.badge.fill", title: "Priority Support", description: "Get help when you need it")
                        }
                        .padding(.horizontal, 24)

                        // Packages
                        VStack(spacing: 12) {
                            if let yearly = yearlyPackage {
                                PackageCard(
                                    package: yearly,
                                    isSelected: selectedPackage?.identifier == yearly.identifier,
                                    badge: "BEST VALUE"
                                ) {
                                    selectedPackage = yearly
                                }
                            }

                            if let monthly = monthlyPackage {
                                PackageCard(
                                    package: monthly,
                                    isSelected: selectedPackage?.identifier == monthly.identifier
                                ) {
                                    selectedPackage = monthly
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        // Purchase Button
                        Button(action: purchase) {
                            HStack {
                                if isPurchasing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Start Free Trial")
                                        .font(.system(size: 18, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color.snapOrange, Color.snapPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                        }
                        .disabled(selectedPackage == nil || isPurchasing)
                        .padding(.horizontal, 24)

                        // Restore Button
                        Button(action: restore) {
                            Text("Restore Purchases")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }

                        // Terms
                        Text("Cancel anytime. Terms apply.")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            if selectedPackage == nil {
                selectedPackage = yearlyPackage ?? monthlyPackage
            }
        }
    }

    private func purchase() {
        guard let package = selectedPackage else { return }

        isPurchasing = true
        Task {
            do {
                _ = try await revenueCatManager.purchase(package: package)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
            isPurchasing = false
        }
    }

    private func restore() {
        isPurchasing = true
        Task {
            do {
                let customerInfo = try await revenueCatManager.restorePurchases()
                if customerInfo.entitlements["Cocorise Pro"]?.isActive == true {
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
            isPurchasing = false
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.snapOrange)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PackageCard: View {
    @Environment(\.colorScheme) var colorScheme
    let package: Package
    let isSelected: Bool
    var badge: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(package.storeProduct.localizedTitle)
                            .font(.system(size: 18, weight: .bold))
                        Text(package.storeProduct.localizedDescription)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.snapOrange)
                            .cornerRadius(8)
                    }
                }

                HStack {
                    Text(package.localizedPriceString)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.snapOrange)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.snapOrange)
                            .font(.system(size: 24))
                    }
                }
            }
            .padding(20)
            .background(Color.snapCard(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.snapOrange : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomPaywallView()
}
