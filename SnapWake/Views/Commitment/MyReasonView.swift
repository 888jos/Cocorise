//
//  MyReasonView.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import SwiftUI

struct MyReasonView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var commitmentManager = CommitmentManager.shared
    @State private var reason: String = ""
    @FocusState private var isTextEditorFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                            .padding()
                    }
                    Spacer()
                }

                Text("Wake Up Reason")
                    .font(.faroSemiBold(size: 20))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .frame(height: 60)
            .background(Color.snapBackground(for: colorScheme))

            // Text Editor with placeholder
            ZStack(alignment: .topLeading) {
                if reason.isEmpty {
                    Text("Why are you committed to waking up early? What do you plan to do first thing in the morning?")
                        .font(.faro(size: 17))
                        .foregroundColor(Color.gray.opacity(0.5))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                }

                TextEditor(text: $reason)
                    .font(.faro(size: 17))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .focused($isTextEditorFocused)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .frame(height: 200)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(16)
            .padding(.horizontal, 24)
            .padding(.top, 24)

            Spacer()

            // Save Button
            Button(action: saveReason) {
                Text("Save")
            }
            .snapPrimaryButton(isEnabled: !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .disabled(reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.snapBackground(for: colorScheme))
        .onAppear {
            reason = commitmentManager.myReason
            isTextEditorFocused = true
        }
    }

    private func saveReason() {
        commitmentManager.myReason = reason
        dismiss()
    }
}

#Preview {
    MyReasonView()
}
