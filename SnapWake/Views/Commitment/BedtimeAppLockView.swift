//
//  BedtimeAppLockView.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import SwiftUI

struct BedtimeAppLockView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var commitmentManager = CommitmentManager.shared
    @State private var selectedDays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
    @State private var showingFromTimePicker = false
    @State private var showingToTimePicker = false

    var formattedFromTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: commitmentManager.appLockStartTime)
    }

    var formattedToTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: commitmentManager.appLockEndTime)
    }

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

                Text("Bedtime App Lock")
                    .font(.faroSemiBold(size: 20))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .frame(height: 60)
            .background(Color.snapBackground(for: colorScheme))

            ScrollView {
                VStack(spacing: 20) {
                    // From/To Times Card
                    VStack(spacing: 0) {
                        // From
                        Button(action: { showingFromTimePicker = true }) {
                            HStack {
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 8, height: 8)

                                    Text("From")
                                        .font(.faro(size: 17))
                                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                }

                                Spacer()

                                Text(formattedFromTime)
                                    .font(.faro(size: 17))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Divider()
                            .padding(.horizontal, 20)

                        // To
                        Button(action: { showingToTimePicker = true }) {
                            HStack {
                                HStack(spacing: 8) {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 8, height: 8)

                                    Text("To")
                                        .font(.faro(size: 17))
                                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                }

                                Spacer()

                                Text(formattedToTime)
                                    .font(.faro(size: 17))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .background(Color.snapCard(for: colorScheme))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    // Days Selector
                    VStack(alignment: .leading, spacing: 16) {
                        Text("On these days:")
                            .font(.faroSemiBold(size: 17))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            .padding(.horizontal, 24)

                        HStack(spacing: 12) {
                            ForEach([Weekday.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday], id: \.self) { day in
                                Button(action: {
                                    if selectedDays.contains(day) {
                                        selectedDays.remove(day)
                                    } else {
                                        selectedDays.insert(day)
                                    }
                                }) {
                                    Text(String(day.shortName.prefix(1)))
                                        .font(.faroSemiBold(size: 17))
                                        .foregroundColor(selectedDays.contains(day) ? .white : Color.snapTextPrimary(for: colorScheme))
                                        .frame(width: 44, height: 44)
                                        .background(selectedDays.contains(day) ? Color.snapOrange : Color.clear)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(selectedDays.contains(day) ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 8)

                    // Apps Blocked
                    Button(action: {}) {
                        HStack {
                            Text("Apps Blocked")
                                .font(.faro(size: 17))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                            Spacer()

                            Text("Block List")
                                .font(.faro(size: 17))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 24)

                    // Schedule Enabled Toggle
                    HStack {
                        Text("Schedule Enabled")
                            .font(.faro(size: 17))
                            .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                        Spacer()

                        Toggle("", isOn: $commitmentManager.isAppLockEnabled)
                            .labelsHidden()
                            .tint(.snapOrange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.snapCard(for: colorScheme))
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    Spacer(minLength: 20)
                }
            }

            // Save Button
            Button(action: {
                dismiss()
            }) {
                Text("Save Schedule")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.snapBackground(for: colorScheme))
        .sheet(isPresented: $showingFromTimePicker) {
            TimePickerView(selectedTime: $commitmentManager.appLockStartTime)
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $showingToTimePicker) {
            TimePickerView(selectedTime: $commitmentManager.appLockEndTime)
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    BedtimeAppLockView()
}
