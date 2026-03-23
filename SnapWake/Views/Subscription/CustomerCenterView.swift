//
//  CustomerCenterView.swift
//  SnapWake
//
//  RevenueCat Customer Center for subscription management
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct CustomerCenterView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        CustomerCenterView()
            .onRestoreCompleted { _ in
                print("✅ Restore completed in Customer Center")
            }
    }
}

#Preview {
    CustomerCenterView()
}
