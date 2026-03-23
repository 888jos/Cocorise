//
//  ChooseMissionView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI

struct ChooseMissionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedMission: Mission?
    @State private var selectedCategory: MissionCategory = .all
    @State private var showingDurationConfig = false
    @State private var showingCountConfig = false
    @State private var showingVersesConfig = false
    @State private var showingItemsConfig = false
    @State private var showingMissionsConfig = false
    @State private var showingAffirmationsConfig = false
    @State private var missionToConfig: Mission?

    var filteredMissions: [Mission] {
        MissionsLibrary.shared.missions(for: selectedCategory)
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

                Text("Choose Mission")
                    .font(.faroBold(size: 16))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(Color.snapBackground(for: colorScheme))

            // Category filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(MissionCategory.allCases, id: \.self) { category in
                        Button(action: { selectedCategory = category }) {
                            HStack(spacing: 5) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 12))

                                Text(category.rawValue)
                                    .font(.faro(size: 13))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedCategory == category ? Color.snapOrange : Color.snapCard(for: colorScheme))
                            .foregroundColor(selectedCategory == category ? .white : Color.snapTextPrimary(for: colorScheme))
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 8)
            .background(Color.snapBackground(for: colorScheme))

            // Missions Grid
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(filteredMissions) { mission in
                        MissionCardButton(
                            mission: mission,
                            isSelected: selectedMission?.id == mission.id
                        ) {
                            handleMissionTap(mission)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .background(Color.snapBackground(for: colorScheme))
        }
        .background(Color.snapBackground(for: colorScheme))
        .sheet(isPresented: $showingDurationConfig) {
            if let mission = missionToConfig {
                DurationConfigSheet(
                    missionName: mission.name,
                    initialDuration: mission.config?.duration ?? 15
                ) { duration in
                    var updatedMission = mission
                    if updatedMission.config == nil {
                        updatedMission.config = MissionConfig()
                    }
                    updatedMission.config?.duration = duration
                    selectedMission = updatedMission
                    showingDurationConfig = false
                    dismiss()
                }
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingCountConfig) {
            if let mission = missionToConfig {
                CountConfigSheet(
                    initialCount: mission.config?.count ?? 30
                ) { count in
                    var updatedMission = mission
                    if updatedMission.config == nil {
                        updatedMission.config = MissionConfig()
                    }
                    updatedMission.config?.count = count
                    selectedMission = updatedMission
                    showingCountConfig = false
                    dismiss()
                }
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingVersesConfig) {
            if let mission = missionToConfig {
                VersesConfigSheet(
                    initialVerses: mission.config?.selectedVerses ?? BibleVerses.popular
                ) { verses in
                    var updatedMission = mission
                    if updatedMission.config == nil {
                        updatedMission.config = MissionConfig()
                    }
                    updatedMission.config?.selectedVerses = verses
                    selectedMission = updatedMission
                    showingVersesConfig = false
                    dismiss()
                }
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingItemsConfig) {
            if let mission = missionToConfig {
                ItemsConfigSheet(
                    initialItems: mission.config?.selectedItems ?? HuntObjects.items
                ) { items in
                    var updatedMission = mission
                    if updatedMission.config == nil {
                        updatedMission.config = MissionConfig()
                    }
                    updatedMission.config?.selectedItems = items
                    selectedMission = updatedMission
                    showingItemsConfig = false
                    dismiss()
                }
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingMissionsConfig) {
            if let mission = missionToConfig {
                MissionsConfigSheet(
                    initialMissions: mission.config?.selectedMissions ?? []
                ) { missions in
                    var updatedMission = mission
                    if updatedMission.config == nil {
                        updatedMission.config = MissionConfig()
                    }
                    updatedMission.config?.selectedMissions = missions
                    selectedMission = updatedMission
                    showingMissionsConfig = false
                    dismiss()
                }
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
        .sheet(isPresented: $showingAffirmationsConfig) {
            if let mission = missionToConfig {
                AffirmationsConfigSheet(
                    initialAffirmations: mission.config?.selectedAffirmations ?? []
                ) { affirmations in
                    var updatedMission = mission
                    if updatedMission.config == nil {
                        updatedMission.config = MissionConfig()
                    }
                    updatedMission.config?.selectedAffirmations = affirmations
                    selectedMission = updatedMission
                    showingAffirmationsConfig = false
                    dismiss()
                }
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
            }
        }
    }

    private func handleMissionTap(_ mission: Mission) {
        missionToConfig = mission

        switch mission.type {
        case .exercise:
            showingDurationConfig = true
        case .shake:
            showingCountConfig = true
        case .text where mission.name == "Bible Verse":
            showingVersesConfig = true
        case .text where mission.name == "Affirmation":
            showingAffirmationsConfig = true
        case .photo where mission.name == "Object Hunt":
            showingItemsConfig = true
        case .random:
            showingMissionsConfig = true
        default:
            // For missions without config, select directly
            selectedMission = mission
            dismiss()
        }
    }
}

struct MissionCardButton: View {
    @Environment(\.colorScheme) var colorScheme
    let mission: Mission
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    // SF Symbol with gradient background
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: mission.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70, height: 70)

                    Image(systemName: mission.icon)
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                }

                Text(mission.name)
                    .font(.faroBold(size: 15))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                Text(mission.description)
                    .font(.faro(size: 11))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                if !mission.isNoMission {
                    Button(action: {}) {
                        Text("Preview")
                            .font(.faro(size: 12))
                            .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Color.snapCardSecondary(for: colorScheme))
                            .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 190)
            .background(Color.snapCard(for: colorScheme))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.snapGreen : Color.clear, lineWidth: 2)
            )
            .overlay(
                isSelected ?
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.snapGreen)
                            .background(Circle().fill(Color.snapBackground(for: colorScheme)))
                            .padding(6)
                    }
                    Spacer()
                }
                : nil
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ChooseMissionView(selectedMission: .constant(nil))
}
