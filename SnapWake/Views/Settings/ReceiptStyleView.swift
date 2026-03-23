//
//  ReceiptStyleView.swift
//  SnapWake
//
//  Wake History Card Style selector
//

import SwiftUI

struct ReceiptStyleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedReceiptStyle") private var selectedReceiptStyle = "Default"
    @State private var selectedIndex = 0

    private var cardOptions: [(name: String, gradient: [Color])] {
        [
            ("Default", [Color(hex: "667EEA"), Color(hex: "764BA2")]),
            ("Morning Glory", [Color(hex: "F093FB"), Color(hex: "F5576C")]),
            ("Night Owl", [Color(hex: "4A00E0"), Color(hex: "8E2DE2")]),
            ("Fresh Start", [Color(hex: "00D2FF"), Color(hex: "3A7BD5")]),
            ("Fire", [Color(hex: "FA8BFF"), Color(hex: "2BFF88"), Color(hex: "F04A4A")]),
            ("Ocean", [Color(hex: "2E3192"), Color(hex: "1BFFFF")])
        ]
    }

    var body: some View {
        ZStack {
            Color.snapBackground(for: colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Text("Choose your\nreceipt style")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color.snapTextPrimary(for: colorScheme))
                        .multilineTextAlignment(.center)

                    Text("This is your proof after every successful wake up")
                        .font(.faro(size: 16))
                        .foregroundColor(Color.snapTextSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 32)
                .padding(.top, 40)

                // Horizontal scroll with paging
                TabView(selection: $selectedIndex) {
                    ForEach(0..<cardOptions.count, id: \.self) { index in
                        wakeHistoryCardOption(cardOptions[index].name, streak: 14, date: "Sat, Mar 7", wakeTime: "7:30", wakeNumber: 42)
                            .padding(.horizontal, 32)
                            .tag(index)
                            .onTapGesture {
                                selectedReceiptStyle = cardOptions[index].name
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 300)
                .onChange(of: selectedIndex) { newIndex in
                    selectedReceiptStyle = cardOptions[newIndex].name
                }
                .onAppear {
                    // Set initial selection based on saved style
                    if let index = cardOptions.firstIndex(where: { $0.name == selectedReceiptStyle }) {
                        selectedIndex = index
                    }
                }

                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<cardOptions.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedIndex ? Color.snapOrange : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == selectedIndex ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedIndex)
                    }
                }
                .padding(.vertical, 20)

                Text(selectedReceiptStyle)
                    .font(.faro(size: 16))
                    .foregroundColor(Color(hex: "666666"))

                Spacer()

                // Save button
                Button(action: {
                    dismiss()
                }) {
                    Text("Save Style")
                        .font(.faroBold(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.snapOrange)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Receipt Style")
        .navigationBarTitleDisplayMode(.inline)
    }

    func wakeHistoryCardOption(_ title: String, streak: Int, date: String, wakeTime: String, wakeNumber: Int) -> some View {
        let gradient = cardOptions.first(where: { $0.name == title })?.gradient ?? []
        let linearGradient = LinearGradient(
            colors: gradient.map { $0 },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        return VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(linearGradient)
                    .frame(height: 250)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, y: 8)

                VStack(spacing: 16) {
                    // Streak
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.white)
                        Text("\(streak) day streak")
                            .font(.faroBold(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)

                    Spacer()

                    // Wake info
                    VStack(spacing: 8) {
                        Text(date)
                            .font(.faro(size: 14))
                            .foregroundColor(.white.opacity(0.9))

                        Text(wakeTime)
                            .font(.faroBold(size: 48))
                            .foregroundColor(.white)

                        Text("Wake #\(wakeNumber)")
                            .font(.faro(size: 14))
                            .foregroundColor(.white.opacity(0.9))
                    }

                    Spacer()
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    ReceiptStyleView()
}
