//
//  ObjectHuntPickerView.swift
//  SnapWake
//
//  Gambling-style random object picker animation
//

import SwiftUI

struct ObjectHuntPickerView: View {
    let availableObjects: [HuntObject]
    let onObjectSelected: (HuntObject) -> Void

    @State private var isSpinning = false
    @State private var selectedObject: HuntObject?
    @State private var scrollOffset: CGFloat = 0
    @State private var finalOffset: CGFloat = 0

    private let itemWidth: CGFloat = 100
    private let itemSpacing: CGFloat = 20

    var body: some View {
        ZStack {
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 40) {
                // Title
                VStack(spacing: 12) {
                    Text("Finding your object...")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .opacity(isSpinning ? 1 : 0)
                        .animation(.easeIn(duration: 0.3), value: isSpinning)

                    Text("Get ready!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .opacity(isSpinning ? 1 : 0)
                        .animation(.easeIn(duration: 0.3).delay(0.2), value: isSpinning)
                }
                .padding(.top, 80)

                Spacer()

                // Gambling machine viewport
                ZStack {
                    // Selection indicator (center box)
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.snapOrange, lineWidth: 4)
                        .frame(width: itemWidth + 20, height: itemWidth + 60)
                        .overlay(
                            VStack {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(.snapOrange)
                                    .font(.system(size: 20))
                                    .offset(y: -50)
                                Spacer()
                                Image(systemName: "arrowtriangle.up.fill")
                                    .foregroundColor(.snapOrange)
                                    .font(.system(size: 20))
                                    .offset(y: 50)
                            }
                        )

                    // Scrolling objects
                    GeometryReader { geometry in
                        HStack(spacing: itemSpacing) {
                            // Triple the objects for seamless loop
                            ForEach(0..<3) { repetition in
                                ForEach(availableObjects) { obj in
                                    ObjectSlot(huntObject: obj)
                                        .frame(width: itemWidth)
                                }
                            }
                        }
                        .offset(x: scrollOffset + geometry.size.width / 2 - itemWidth / 2)
                    }
                    .frame(height: itemWidth + 60)
                    .clipped()
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .black, location: 0.15),
                                .init(color: .black, location: 0.85),
                                .init(color: .clear, location: 1)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                }
                .frame(height: itemWidth + 60)

                Spacer()

                // Result display
                if let selected = selectedObject {
                    VStack(spacing: 16) {
                        Text("Your mission:")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)

                        VStack(spacing: 12) {
                            Text(selected.emoji)
                                .font(.system(size: 80))

                            Text(selected.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(30)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                Spacer()
            }
        }
        .onAppear {
            startGamblingAnimation()
        }
    }

    private func startGamblingAnimation() {
        guard !availableObjects.isEmpty else { return }

        // Select random object
        let randomObject = availableObjects.randomElement()!

        // Start spinning immediately
        isSpinning = true

        // Calculate final position to land on the selected object
        let objectIndex = availableObjects.firstIndex(where: { $0.id == randomObject.id }) ?? 0
        let middleRepetition = availableObjects.count // Use middle set of objects
        let targetIndex = middleRepetition + objectIndex
        let totalItemWidth = itemWidth + itemSpacing

        // Start from far right and spin left
        scrollOffset = totalItemWidth * 10

        // Final position (centered on selected object)
        finalOffset = -totalItemWidth * CGFloat(targetIndex)

        // Fast spinning phase (2 seconds)
        withAnimation(.linear(duration: 2.0)) {
            scrollOffset = -totalItemWidth * CGFloat(availableObjects.count * 2)
        }

        // Slowing down phase (1.5 seconds) with easeOut
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 1.5)) {
                scrollOffset = finalOffset
            }
        }

        // Show result
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            withAnimation(.spring()) {
                selectedObject = randomObject
            }

            // Proceed to mission after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onObjectSelected(randomObject)
            }
        }
    }
}

struct ObjectSlot: View {
    let huntObject: HuntObject

    var body: some View {
        VStack(spacing: 8) {
            Text(huntObject.emoji)
                .font(.system(size: 60))

            Text(huntObject.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(width: 100)
    }
}

#Preview {
    ObjectHuntPickerView(
        availableObjects: Array(HuntObjects.allObjects.prefix(10))
    ) { obj in
        print("Selected: \(obj.name)")
    }
}
