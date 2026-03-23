//
//  EditAlarmView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared

    let alarm: Alarm?
    @State private var name: String
    @State private var time: Date
    @State private var selectedDays: Set<Weekday>
    @State private var difficulty: Difficulty
    @State private var sound: String
    @State private var isScheduled = true
    @State private var selectedMission: Mission?
    @State private var showingMissionPicker = false
    @State private var showingSoundPicker = false
    @State private var showingTimePicker = false

    init(alarm: Alarm?) {
        self.alarm = alarm
        _name = State(initialValue: alarm?.name ?? "My Alarm")
        _time = State(initialValue: alarm?.time ?? Date())
        _selectedDays = State(initialValue: alarm?.selectedDays ?? [])
        _difficulty = State(initialValue: alarm?.difficulty ?? .easy)
        _sound = State(initialValue: alarm?.sound ?? "Default")
        _selectedMission = State(initialValue: MissionsLibrary.shared.missions.first(where: { $0.isNoMission }))
    }

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

                Text(alarm == nil ? "New Alarm" : "Edit Alarm")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Color.snapBackground(for: colorScheme))

            // Contenu scrollable
            ScrollView {
                VStack(spacing: 16) {
                    // Alarm Name
                    TextField("Alarm name", text: $name)
                        .font(.faroBold(size: 20))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(12)
                        .padding(.horizontal)

                    // Alarm Time
                    Button(action: { showingTimePicker = true }) {
                        HStack {
                            Text("Alarm Time")
                                .font(.faro(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            Spacer()
                            Text(formatTime(time))
                                .font(.faroBold(size: 16))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                .font(.system(size: 14))
                        }
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

                    // Scheduled / One-time
                    HStack(spacing: 10) {
                        Button(action: { isScheduled = true }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 14))
                                Text("Scheduled")
                                    .font(.faro(size: 15))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isScheduled ? Color.snapOrange : Color.snapCard(for: colorScheme))
                            .foregroundColor(isScheduled ? .white : Color.snapTextPrimary(for: colorScheme))
                            .cornerRadius(12)
                        }

                        Button(action: { isScheduled = false }) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 14))
                                Text("One-time")
                                    .font(.faro(size: 15))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(!isScheduled ? Color.snapOrange : Color.snapCard(for: colorScheme))
                            .foregroundColor(!isScheduled ? .white : Color.snapTextPrimary(for: colorScheme))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)

                    // Repeat on (jours)
                    if isScheduled {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Repeat on:")
                                .font(.faro(size: 15))
                                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                                .padding(.horizontal)

                            HStack(spacing: 8) {
                                ForEach([Weekday.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday], id: \.self) { day in
                                    Button(action: {
                                        if selectedDays.contains(day) {
                                            selectedDays.remove(day)
                                        } else {
                                            selectedDays.insert(day)
                                        }
                                    }) {
                                        Text(String(day.shortName.prefix(1)))
                                            .font(.faroBold(size: 15))
                                            .frame(width: 40, height: 40)
                                            .background(selectedDays.contains(day) ? Color.snapOrange : Color.snapCard(for: colorScheme))
                                            .foregroundColor(selectedDays.contains(day) ? .white : Color.snapTextPrimary(for: colorScheme))
                                            .clipShape(Circle())
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Mission Card
                    Button(action: { showingMissionPicker = true }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: selectedMission?.gradient ?? [.gray],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 55, height: 55)

                                Image(systemName: selectedMission?.icon ?? "bell.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mission")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                                Text(selectedMission?.name ?? "No Mission")
                                    .font(.faroBold(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                                Text(selectedMission?.description ?? "")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                    .lineLimit(1)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                .font(.system(size: 14))
                        }
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

                    // Sound Card
                    Button(action: { showingSoundPicker = true }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient.snapNight)
                                    .frame(width: 50, height: 50)

                                Image(systemName: "music.note")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sound")
                                    .font(.faro(size: 12))
                                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                                Text(sound)
                                    .font(.faroBold(size: 16))
                                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                                .font(.system(size: 14))
                        }
                        .padding()
                        .background(Color.snapCard(for: colorScheme))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal)

                    // Save Button
                    Button(action: saveAlarm) {
                        Text("Save Alarm")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.snapOrange)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                .padding(.top, 12)
            }
        }
        .background(Color.snapBackground(for: colorScheme))
        .sheet(isPresented: $showingMissionPicker) {
            ChooseMissionView(selectedMission: $selectedMission)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showingSoundPicker) {
            SoundsView(selectedSoundName: $sound)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
        .sheet(isPresented: $showingTimePicker) {
            TimePickerView(selectedTime: $time)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func saveAlarm() {
        if let existingAlarm = alarm {
            let updatedAlarm = Alarm(
                id: existingAlarm.id,
                name: name,
                time: time,
                isEnabled: true,
                selectedDays: selectedDays,
                difficulty: difficulty,
                sound: sound,
                missionId: selectedMission?.id
            )
            alarmManager.updateAlarm(updatedAlarm)
        } else {
            let newAlarm = Alarm(
                name: name,
                time: time,
                isEnabled: true,
                selectedDays: selectedDays,
                difficulty: difficulty,
                sound: sound,
                missionId: selectedMission?.id
            )
            alarmManager.addAlarm(newAlarm)
        }
        dismiss()
    }
}

#Preview {
    EditAlarmView(alarm: nil)
}
