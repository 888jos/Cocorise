//
//  MissionConfigSheet.swift
//  SnapWake
//
//  Created by Josselin Biot on 08/03/2026.
//

import SwiftUI

// Reps Config (for Push Ups, Squats)
struct DurationConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    let missionName: String
    @State private var reps: Int
    let onSave: (Int) -> Void

    init(missionName: String, initialDuration: Int = 10, onSave: @escaping (Int) -> Void) {
        self.missionName = missionName
        self._reps = State(initialValue: initialDuration)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }

            Text("\(missionName.replacingOccurrences(of: "s", with: "")) Reps")
                .font(.faroSemiBold(size: 20))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.vertical, 20)

            Spacer()

            // Reps Picker
            HStack(spacing: 16) {
                Button(action: {
                    if reps > 5 {
                        reps -= 5
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.snapOrange)
                }

                Text("\(reps)")
                    .font(.faroBold(size: 60))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .frame(minWidth: 120)

                Button(action: {
                    if reps < 50 {
                        reps += 5
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.snapOrange)
                }
            }

            Spacer()

            // Done Button
            Button(action: {
                onSave(reps)
            }) {
                Text("Done")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.snapBackground(for: colorScheme))
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
    }
}

// Count Config (for Shake Phone)
struct CountConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var count: Int
    let onSave: (Int) -> Void

    init(initialCount: Int = 30, onSave: @escaping (Int) -> Void) {
        self._count = State(initialValue: initialCount)
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with close button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }

            Text("Shake Count")
                .font(.faroSemiBold(size: 20))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.vertical, 20)

            Spacer()

            // Count Picker
            HStack(spacing: 16) {
                Button(action: {
                    if count > 10 {
                        count -= 10
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.snapOrange)
                }

                Text("\(count)")
                    .font(.faroBold(size: 60))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .frame(minWidth: 120)

                Button(action: {
                    if count < 100 {
                        count += 10
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.snapOrange)
                }
            }

            Spacer()

            // Done Button
            Button(action: {
                onSave(count)
            }) {
                Text("Done")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.snapBackground(for: colorScheme))
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
    }
}

// Bible Verses Selection Sheet
struct VersesConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedVerses: Set<String>
    @State private var showingError = false
    let onSave: ([String]) -> Void

    init(initialVerses: [String] = BibleVerses.popular, onSave: @escaping ([String]) -> Void) {
        self._selectedVerses = State(initialValue: Set(initialVerses))
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }

            Text("Select Verses")
                .font(.faroBold(size: 24))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.bottom, 20)

            HStack {
                Text("\(selectedVerses.count) selected")
                    .font(.faro(size: 15))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()

                Button(action: {
                    if selectedVerses.count == BibleVerses.allVerses.count {
                        // All selected -> deselect all
                        selectedVerses.removeAll()
                    } else {
                        // Not all selected -> select all
                        selectedVerses = Set(BibleVerses.allVerses.map { $0.reference })
                    }
                }) {
                    Text(selectedVerses.count == BibleVerses.allVerses.count ? "Deselect All" : "Select All")
                        .font(.faroSemiBold(size: 15))
                        .foregroundColor(.snapOrange)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            Text("A random verse from your selection will be shown each morning")
                .font(.faro(size: 14))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 12) {
                    Text("POPULAR VERSES")
                        .font(.faroSemiBold(size: 13))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)

                    ForEach(BibleVerses.allVerses) { bibleVerse in
                        VerseRow(
                            bibleVerse: bibleVerse,
                            isSelected: selectedVerses.contains(bibleVerse.reference)
                        ) {
                            if selectedVerses.contains(bibleVerse.reference) {
                                selectedVerses.remove(bibleVerse.reference)
                            } else {
                                selectedVerses.insert(bibleVerse.reference)
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .scrollBounceBehavior(.basedOnSize)

            // Done Button
            Button(action: {
                if selectedVerses.isEmpty {
                    showingError = true
                } else {
                    onSave(Array(selectedVerses))
                }
            }) {
                Text("Done")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.snapBackground(for: colorScheme))
        .presentationDragIndicator(.hidden)
        .alert("Selection Required", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select at least one verse")
        }
    }
}

struct VerseRow: View {
    @Environment(\.colorScheme) var colorScheme
    let bibleVerse: BibleVerse
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .snapGreen : Color.gray.opacity(0.3))

                VStack(alignment: .leading, spacing: 4) {
                    Text(bibleVerse.reference)
                        .font(.faroSemiBold(size: 16))
                        .foregroundColor(Color.snapOrange)

                    Text(bibleVerse.text)
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .lineLimit(2)
                }

                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.snapGreen.opacity(0.05) : Color.snapCard(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.snapGreen : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 24)
    }
}

// Object Hunt Items Selection Sheet
struct ItemsConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedItems: Set<String>
    @State private var showingError = false
    let onSave: ([String]) -> Void

    init(initialItems: [String] = HuntObjects.items, onSave: @escaping ([String]) -> Void) {
        self._selectedItems = State(initialValue: Set(initialItems))
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }

            Text("Select Items")
                .font(.faroBold(size: 24))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.bottom, 20)

            HStack {
                Text("\(selectedItems.count) selected")
                    .font(.faro(size: 15))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()

                Button(action: {
                    if selectedItems.count == HuntObjects.allObjects.count {
                        // All selected -> deselect all
                        selectedItems.removeAll()
                    } else {
                        // Not all selected -> select all
                        selectedItems = Set(HuntObjects.allObjects.map { $0.name })
                    }
                }) {
                    Text(selectedItems.count == HuntObjects.allObjects.count ? "Deselect All" : "Select All")
                        .font(.faroSemiBold(size: 15))
                        .foregroundColor(.snapOrange)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            Text("A random item will be chosen each morning")
                .font(.faro(size: 14))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(HuntObjects.allObjects) { huntObject in
                        ItemCard(huntObject: huntObject, isSelected: selectedItems.contains(huntObject.name)) {
                            if selectedItems.contains(huntObject.name) {
                                selectedItems.remove(huntObject.name)
                            } else {
                                selectedItems.insert(huntObject.name)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }
            .scrollBounceBehavior(.basedOnSize)

            // Done Button
            Button(action: {
                if selectedItems.isEmpty {
                    showingError = true
                } else {
                    onSave(Array(selectedItems))
                }
            }) {
                Text("Done")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.snapBackground(for: colorScheme))
        .presentationDragIndicator(.hidden)
        .alert("Selection Required", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select at least one object")
        }
    }
}

struct ItemCard: View {
    @Environment(\.colorScheme) var colorScheme
    let huntObject: HuntObject
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Text(huntObject.emoji)
                        .font(.system(size: 40))

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.snapGreen)
                            .background(Circle().fill(Color.snapBackground(for: colorScheme)))
                    }
                }
                .frame(height: 50)

                Text(huntObject.name)
                    .font(.faroSemiBold(size: 13))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(isSelected ? Color.snapGreen.opacity(0.05) : Color.snapCard(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.snapGreen : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Random Mission Selection Sheet
struct MissionsConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedMissions: Set<String>
    @State private var showingError = false
    let onSave: ([String]) -> Void

    init(initialMissions: [String] = [], onSave: @escaping ([String]) -> Void) {
        // If empty, select all missions by default (except "No Mission" and "Random")
        let defaultMissions = initialMissions.isEmpty
            ? MissionsLibrary.shared.missions
                .filter { !$0.isNoMission && $0.type != .random }
                .map { $0.name }
            : initialMissions
        self._selectedMissions = State(initialValue: Set(defaultMissions))
        self.onSave = onSave
    }

    private var availableMissions: [Mission] {
        MissionsLibrary.shared.missions.filter { !$0.isNoMission && $0.type != .random }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }

            Text("Select Missions")
                .font(.faroBold(size: 24))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.bottom, 20)

            HStack {
                Text("\(selectedMissions.count) selected")
                    .font(.faro(size: 15))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()

                Button(action: {
                    if selectedMissions.count == availableMissions.count {
                        // All selected -> deselect all
                        selectedMissions.removeAll()
                    } else {
                        // Not all selected -> select all
                        selectedMissions = Set(availableMissions.map { $0.name })
                    }
                }) {
                    Text(selectedMissions.count == availableMissions.count ? "Deselect All" : "Select All")
                        .font(.faroSemiBold(size: 15))
                        .foregroundColor(.snapOrange)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            Text("A random mission from your selection will be chosen each morning")
                .font(.faro(size: 14))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(availableMissions) { mission in
                        MissionRow(
                            mission: mission,
                            isSelected: selectedMissions.contains(mission.name)
                        ) {
                            if selectedMissions.contains(mission.name) {
                                selectedMissions.remove(mission.name)
                            } else {
                                selectedMissions.insert(mission.name)
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .scrollBounceBehavior(.basedOnSize)

            // Done Button
            Button(action: {
                if selectedMissions.isEmpty {
                    showingError = true
                } else {
                    onSave(Array(selectedMissions))
                }
            }) {
                Text("Done")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.snapBackground(for: colorScheme))
        .presentationDragIndicator(.hidden)
        .alert("Selection Required", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select at least one mission")
        }
    }
}

struct MissionRow: View {
    @Environment(\.colorScheme) var colorScheme
    let mission: Mission
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .snapGreen : Color.gray.opacity(0.3))

                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: mission.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)

                    Image(systemName: mission.icon)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(mission.name)
                        .font(.faroSemiBold(size: 16))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))

                    Text(mission.description)
                        .font(.faro(size: 14))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .lineLimit(1)
                }

                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.snapGreen.opacity(0.05) : Color.snapCard(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.snapGreen : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 24)
    }
}

// Affirmations Selection Sheet
struct AffirmationsConfigSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedAffirmations: Set<String>
    @State private var showingError = false
    let onSave: ([String]) -> Void

    init(initialAffirmations: [String] = [], onSave: @escaping ([String]) -> Void) {
        // If empty, select all affirmations by default
        let defaultAffirmations = initialAffirmations.isEmpty
            ? Affirmations.affirmations
            : initialAffirmations
        self._selectedAffirmations = State(initialValue: Set(defaultAffirmations))
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
            }

            Text("Select Affirmations")
                .font(.faroBold(size: 24))
                .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                .padding(.bottom, 20)

            HStack {
                Text("\(selectedAffirmations.count) selected")
                    .font(.faro(size: 15))
                    .foregroundColor(Color.snapTextSecondary(for: colorScheme))

                Spacer()

                Button(action: {
                    if selectedAffirmations.count == Affirmations.allAffirmations.count {
                        // All selected -> deselect all
                        selectedAffirmations.removeAll()
                    } else {
                        // Not all selected -> select all
                        selectedAffirmations = Set(Affirmations.allAffirmations.map { $0.text })
                    }
                }) {
                    Text(selectedAffirmations.count == Affirmations.allAffirmations.count ? "Deselect All" : "Select All")
                        .font(.faroSemiBold(size: 15))
                        .foregroundColor(.snapOrange)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            Text("A random affirmation from your selection will be shown each morning")
                .font(.faro(size: 14))
                .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Affirmations.allAffirmations) { affirmation in
                        AffirmationRow(
                            affirmation: affirmation,
                            isSelected: selectedAffirmations.contains(affirmation.text)
                        ) {
                            if selectedAffirmations.contains(affirmation.text) {
                                selectedAffirmations.remove(affirmation.text)
                            } else {
                                selectedAffirmations.insert(affirmation.text)
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            .scrollBounceBehavior(.basedOnSize)

            // Done Button
            Button(action: {
                if selectedAffirmations.isEmpty {
                    showingError = true
                } else {
                    onSave(Array(selectedAffirmations))
                }
            }) {
                Text("Done")
            }
            .snapPrimaryButton()
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
        .background(Color.snapBackground(for: colorScheme))
        .presentationDragIndicator(.hidden)
        .alert("Selection Required", isPresented: $showingError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please select at least one affirmation")
        }
    }
}

struct AffirmationRow: View {
    @Environment(\.colorScheme) var colorScheme
    let affirmation: Affirmation
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .snapGreen : Color.gray.opacity(0.3))

                Text(affirmation.text)
                    .font(.faro(size: 15))
                    .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.snapGreen.opacity(0.05) : Color.snapCard(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.snapGreen : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 24)
    }
}

#Preview {
    DurationConfigSheet(missionName: "Push Ups") { _ in }
}
