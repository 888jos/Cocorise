//
//  TextMissionView.swift
//  SnapWake
//
//  Vue pour missions texte (Bible, Affirmations)
//

import SwiftUI

struct TextMissionView: View {
    let mission: Mission
    let onComplete: (Bool) -> Void

    @State private var selectedText: String = ""
    @State private var hasRead = false
    @State private var readingProgress: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0

    var textContent: [String] {
        switch mission.name {
        case "Bible Verse":
            return TextMissionBibleVerses.verses
        case "Affirmation":
            return Affirmations.affirmations
        default:
            return ["Take a moment to reflect on your goals for today."]
        }
    }

    var body: some View {
        ZStack {
            // Clean background
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text(mission.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)

                    Text("Read and reflect")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)

                    // Reading progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)

                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.snapOrange)
                                .frame(width: geometry.size.width * readingProgress, height: 8)
                                .animation(.spring(), value: readingProgress)
                        }
                    }
                    .frame(height: 8)
                    .padding(.horizontal, 40)
                }
                .padding(.top, 60)

                // Text content card
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            // Icon
                            Image(systemName: mission.name == "Bible Verse" ? "book.fill" : "star.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.snapOrange)
                                .padding(.top, 30)

                            // Main text
                            Text(selectedText)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineSpacing(8)
                                .padding(.horizontal, 30)

                            // Attribution (for Bible verses)
                            if mission.name == "Bible Verse" {
                                Text("— Holy Bible")
                                    .font(.system(size: 16, design: .serif))
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                            }

                            Color.clear.frame(height: 30)
                                .id("bottom")
                        }
                        .padding(.bottom, 20)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: geo.frame(in: .named("scroll")).minY
                                )
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        updateReadingProgress(offset: value)
                    }
                }
                .frame(maxHeight: 400)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 10)
                .padding(.horizontal, 20)

                Spacer()

                // Complete button
                Button(action: completeReading) {
                    Text(readingProgress >= 0.9 ? "Complete" : "Scroll to finish")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(readingProgress >= 0.9 ? Color.black : Color.gray.opacity(0.3))
                        .cornerRadius(30)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .disabled(readingProgress < 0.9)
            }
        }
        .onAppear {
            selectedText = textContent.randomElement() ?? textContent[0]
        }
    }

    private func updateReadingProgress(offset: CGFloat) {
        // Calculate reading progress based on scroll
        let progress = min(max(-offset / 300, 0), 1)
        readingProgress = progress
    }

    private func completeReading() {
        guard readingProgress >= 0.9 else { return }
        onComplete(true)
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Bible Verses for Text Mission
struct TextMissionBibleVerses {
    static let verses = [
        "This is the day the Lord has made; let us rejoice and be glad in it.\n\nPsalm 118:24",
        "I can do all things through Christ who strengthens me.\n\nPhilippians 4:13",
        "For God has not given us a spirit of fear, but of power and of love and of a sound mind.\n\n2 Timothy 1:7",
        "The Lord is my strength and my shield; my heart trusts in him, and he helps me.\n\nPsalm 28:7",
        "Commit to the Lord whatever you do, and he will establish your plans.\n\nProverbs 16:3",
        "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.\n\nJoshua 1:9",
        "Trust in the Lord with all your heart and lean not on your own understanding.\n\nProverbs 3:5",
        "The Lord is my light and my salvation—whom shall I fear?\n\nPsalm 27:1",
        "Wait for the Lord; be strong and take heart and wait for the Lord.\n\nPsalm 27:14",
        "In all your ways submit to him, and he will make your paths straight.\n\nProverbs 3:6"
    ]
}

// MARK: - Affirmations
// Moved to Mission.swift for centralized management
