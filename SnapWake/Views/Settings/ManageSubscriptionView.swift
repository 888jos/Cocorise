//
//  ManageSubscriptionView.swift
//  SnapWake
//
//  Manage subscription and billing
//

import SwiftUI
import StoreKit

struct ManageSubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading = false
    @State private var showingCancelAlert = false
    @State private var subscriptionStatus = "Active"

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Subscription status card
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.snapGreen)

                        Text("Premium Active")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                        Text("Your subscription is active")
                            .font(.faro(size: 16))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    }
                    .padding(.top, 40)

                    // Subscription details
                    VStack(spacing: 0) {
                        DetailRow(label: "Plan", value: "Monthly Premium")
                        Divider().padding(.horizontal)
                        DetailRow(label: "Price", value: "$4.99/month")
                        Divider().padding(.horizontal)
                        DetailRow(label: "Next billing date", value: "Apr 21, 2026")
                        Divider().padding(.horizontal)
                        DetailRow(label: "Status", value: subscriptionStatus)
                    }
                    .background(Color.snapCard(for: colorScheme))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    // Actions
                    VStack(spacing: 12) {
                        Button(action: {
                            openManageSubscriptions()
                        }) {
                            HStack {
                                Image(systemName: "gear")
                                Text("Manage in App Store")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            .font(.faroBold(size: 16))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                        }

                        Button(action: {
                            showingCancelAlert = true
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("Cancel Subscription")
                                Spacer()
                            }
                            .font(.faroBold(size: 16))
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.snapCard(for: colorScheme))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Benefits reminder
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Premium Benefits")
                            .font(.faroBold(size: 18))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                        BenefitRow(icon: "checkmark.circle.fill", text: "Unlimited alarms")
                        BenefitRow(icon: "checkmark.circle.fill", text: "All wake-up missions")
                        BenefitRow(icon: "checkmark.circle.fill", text: "Cloud sync")
                        BenefitRow(icon: "checkmark.circle.fill", text: "Priority support")
                    }
                    .padding(20)
                    .background(Color.snapCard(for: colorScheme))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Manage Subscription")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Cancel Subscription", isPresented: $showingCancelAlert) {
            Button("Keep Subscription", role: .cancel) { }
            Button("Cancel", role: .destructive) {
                openManageSubscriptions()
            }
        } message: {
            Text("To cancel your subscription, you'll need to manage it through the App Store settings.")
        }
    }

    func openManageSubscriptions() {
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }
}

struct DetailRow: View {
    @Environment(\.colorScheme) var colorScheme
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
            Spacer()
            Text(value)
                .font(.faroBold(size: 15))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

struct BenefitRow: View {
    @Environment(\.colorScheme) var colorScheme
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.snapGreen)
                .font(.system(size: 18))
            Text(text)
                .font(.faro(size: 15))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            Spacer()
        }
    }
}

#Preview {
    ManageSubscriptionView()
}
