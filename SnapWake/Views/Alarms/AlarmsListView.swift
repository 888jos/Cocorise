//
//  AlarmsListView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct AlarmsListView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared
    @State private var showingAddAlarm = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.snapBackground(for: colorScheme)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    if alarmManager.alarms.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(alarmManager.alarms) { alarm in
                                    AlarmRowView(alarm: alarm)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Alarms")

                // Bouton + floating en bas à droite
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddAlarm = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [Color.snapOrange, Color.snapPink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: Color.snapOrange.opacity(0.4), radius: 15, y: 8)
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 75) // Au-dessus de la tab bar
                    }
                }

                .sheet(isPresented: $showingAddAlarm) {
                    EditAlarmView(alarm: nil)
                }
            }
        }
    }

    private var emptyStateView: some View {
        HStack(spacing: 24) {
            // Mascotte à gauche
            Image("mascotte_alarm")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)

            // Texte à droite
            VStack(alignment: .leading, spacing: 12) {
                Text("No alarms yet")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Text("Tap + to create your first alarm and start waking up with purpose!")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

struct AlarmRowView: View {
    @Environment(\.colorScheme) var colorScheme
    let alarm: Alarm
    @StateObject private var alarmManager = AlarmManager.shared
    @State private var showingEditAlarm = false
    @State private var showingDeleteConfirmation = false

    var sound: AlarmSound {
        SoundsLibrary.shared.sound(named: alarm.sound) ?? SoundsLibrary.shared.sounds[0]
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(alarm.name)
                    .font(.faro(size: 16))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()

                Button(action: { showingDeleteConfirmation = true }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }

            HStack {
                Text(alarm.daysDescription)
                    .font(.faro(size: 14))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()
            }

            HStack(alignment: .lastTextBaseline) {
                Text(alarm.formattedTime)
                    .font(.faroBold(size: 52))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Spacer()

                Toggle("", isOn: Binding(
                    get: { alarm.isEnabled },
                    set: { _ in alarmManager.toggleAlarm(alarm) }
                ))
                .labelsHidden()
                .tint(.snapOrange)
            }

            // Mission and Sound badges
            HStack(spacing: 8) {
                // Mission badge
                HStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: alarm.mission?.gradient ?? [.gray],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)

                        Image(systemName: alarm.mission?.icon ?? "bell.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }

                    Text(alarm.mission?.name ?? "None")
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.snapCardSecondary(for: colorScheme))
                .cornerRadius(20)

                // Sound badge
                HStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient.snapNight)
                            .frame(width: 32, height: 32)

                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }

                    Text(sound.name)
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.snapCardSecondary(for: colorScheme))
                .cornerRadius(20)

                Spacer()
            }
        }
        .padding()
        .background(Color.snapCard(for: colorScheme))
        .cornerRadius(16)
        .onTapGesture {
            showingEditAlarm = true
        }
        .sheet(isPresented: $showingEditAlarm) {
            EditAlarmView(alarm: alarm)
        }
        .alert("Delete Alarm", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                alarmManager.deleteAlarm(alarm)
            }
        } message: {
            Text("Are you sure you want to delete \"\(alarm.name)\"? This action cannot be undone.")
        }
    }
}

#Preview {
    AlarmsListView()
}
