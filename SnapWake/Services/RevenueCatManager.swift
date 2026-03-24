//
//  RevenueCatManager.swift
//  SnapWake
//
//  RevenueCat subscription manager
//

import Foundation
import RevenueCat

@MainActor
class RevenueCatManager: NSObject, ObservableObject {
    static let shared = RevenueCatManager()

    @Published var customerInfo: CustomerInfo?
    @Published var offerings: Offerings?
    @Published var isProMember: Bool = false

    // Entitlement identifier from RevenueCat dashboard
    private let proEntitlementID = "Cocorise Pro"

    private override init() {
        super.init()
        configure()
    }

    // MARK: - Configuration

    func configure() {
        // Configure RevenueCat with your API key
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "test_rHKEiXETXyGXlaWvxqsnTTMZfeG")

        // Set up delegate for customer info updates
        Purchases.shared.delegate = self

        // Load initial customer info
        Task {
            await refreshCustomerInfo()
            await loadOfferings()
        }
    }

    // MARK: - Customer Info

    func refreshCustomerInfo() async {
        do {
            let info = try await Purchases.shared.customerInfo()
            await MainActor.run {
                self.customerInfo = info
                self.isProMember = info.entitlements[proEntitlementID]?.isActive == true
            }
            print("✅ Customer Info refreshed")
            print("   Is Pro: \(isProMember)")
        } catch {
            print("❌ Error fetching customer info: \(error.localizedDescription)")
        }
    }

    // MARK: - Offerings

    func loadOfferings() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            await MainActor.run {
                self.offerings = offerings
            }
            print("✅ Offerings loaded: \(offerings.all.count) offerings")
            if let current = offerings.current {
                print("   Current offering: \(current.identifier)")
                print("   Packages: \(current.availablePackages.map { $0.identifier })")
            }
        } catch {
            print("❌ Error loading offerings: \(error.localizedDescription)")
        }
    }

    // MARK: - Purchase

    func purchase(package: Package) async throws -> CustomerInfo {
        do {
            let (_, customerInfo, _) = try await Purchases.shared.purchase(package: package)
            await MainActor.run {
                self.customerInfo = customerInfo
                self.isProMember = customerInfo.entitlements[proEntitlementID]?.isActive == true
            }
            print("✅ Purchase successful")
            return customerInfo
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Restore

    func restorePurchases() async throws -> CustomerInfo {
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            await MainActor.run {
                self.customerInfo = customerInfo
                self.isProMember = customerInfo.entitlements[proEntitlementID]?.isActive == true
            }
            print("✅ Purchases restored")
            return customerInfo
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Entitlement Checking

    func hasProAccess() -> Bool {
        return isProMember
    }

    func checkEntitlement(_ identifier: String) -> Bool {
        return customerInfo?.entitlements[identifier]?.isActive == true
    }

    // MARK: - Customer Center

    func showCustomerCenter() {
        // Customer Center is shown via CustomerCenterView
        // This method can be used to prepare any data if needed
    }
}

// MARK: - PurchasesDelegate

extension RevenueCatManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            self.isProMember = customerInfo.entitlements[proEntitlementID]?.isActive == true
            print("🔄 Customer info updated - Is Pro: \(isProMember)")
        }
    }
}
