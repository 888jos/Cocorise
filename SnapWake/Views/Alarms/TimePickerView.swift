//
//  TimePickerView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct TimePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTime: Date

    var body: some View {
        VStack(spacing: 0) {
            // Header fixe - très compact
            ZStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }

                Text("Select Time")
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Color.snapBackground(for: colorScheme))

            Spacer()

            // Time Picker
            VStack(spacing: 24) {
                DatePicker(
                    "Alarm Time",
                    selection: $selectedTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()

                // Confirm button
                Button(action: { dismiss() }) {
                    Text("Confirm")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapPink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
            }

            Spacer()
        }
        .background(Color.snapBackground(for: colorScheme))
    }
}

#Preview {
    TimePickerView(selectedTime: .constant(Date()))
}
