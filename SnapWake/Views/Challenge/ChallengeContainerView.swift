//
//  ChallengeContainerView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct ChallengeContainerView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var challengeManager = ChallengeManager.shared
    @StateObject private var alarmManager = AlarmManager.shared
    let alarm: Alarm
    let mission: Mission
    let onDismiss: (Bool) -> Void

    @State private var showingIntro = true

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            if showingIntro {
                // Show intro screen first
                MissionIntroView(mission: mission) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showingIntro = false
                    }
                }
            } else {
                // Then show mission execution view
                MissionExecutionView(alarm: alarm)
            }
        }
    }

}

#Preview {
    ChallengeContainerView(
        alarm: Alarm(
            name: "Morning Alarm",
            time: Date(),
            isEnabled: true,
            selectedDays: [.monday, .tuesday],
            difficulty: .medium,
            sound: "Default"
        ),
        mission: MissionsLibrary.shared.missions.first(where: { $0.type == .math })!,
        onDismiss: { _ in }
    )
}
