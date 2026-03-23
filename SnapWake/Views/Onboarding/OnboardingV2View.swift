//
//  OnboardingV2View.swift
//  SnapWake
//
//  Chat-style onboarding with Coco mascot
//

import SwiftUI

struct OnboardingV2View: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared
    @Binding var isComplete: Bool

    @State private var messages: [ChatMessage] = []
    @State private var currentMessageIndex = 0
    @State private var userName = ""
    @State private var showingInput = false
    @State private var currentInput = ""
    @State private var showTypingIndicator = false
    @State private var userAge = ""
    @State private var selectedSnoozeTime = ""
    @State private var guiltyFeeling = ""
    @State private var currentWakeTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 7
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var panicFeeling = ""
    @State private var alarmsCount = ""
    @State private var forgetTurnOff = ""
    @State private var selfThought = ""
    @State private var triesCount = ""
    @State private var dreamActivity = ""
    @State private var lifeDifference = ""
    @State private var biggestDream = ""
    @State private var futureFeeling = ""
    @State private var selectedMission = ""
    @State private var desiredWakeTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 7
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var selectedSound = "Default"
    @State private var selectedDays: Set<String> = []
    @State private var heardAboutUs = ""
    @State private var commitment = ""
    @State private var transitionToV1 = false

    let conversationFlow: [ConversationStep] = [
        // Intro
        .cocoMessage("Hey! 👋", mascot: "mascot_bienvenue"),
        .cocoMessage("I'm Coco, your morning coach!", mascot: "mascot_bienvenue"),
        .cocoMessage("I'm here to help you become a morning person ☀️", mascot: "mascot_guide"),

        // Name
        .cocoMessage("What's your first name?", mascot: "mascot_guide"),
        .userInput(.name),
        .cocoMessage("Nice to meet you, {name}! 🎉", mascot: "mascot_victoire"),
        .cocoMessage("I'll ask you a few quick questions to personalize your experience", mascot: "mascot_guide"),
        .ctaButton("Ready when you are!", buttonText: "Let's go! 🚀"),

        .transitionToVisual
    ]

    var body: some View {
        ZStack {
            Color.snapLightBackground
                .ignoresSafeArea()

            if transitionToV1 {
                OnboardingV1Wrapper(
                    isComplete: $isComplete,
                    userName: userName,
                    userAge: userAge,
                    snoozeTime: selectedSnoozeTime,
                    guiltyFeeling: guiltyFeeling,
                    panicFeeling: panicFeeling,
                    dreamActivity: dreamActivity,
                    alarmsCount: alarmsCount,
                    forgetTurnOff: forgetTurnOff,
                    lifeDifference: lifeDifference,
                    selfThought: selfThought,
                    triesCount: triesCount,
                    biggestDream: biggestDream,
                    commitment: commitment,
                    futureFeeling: futureFeeling,
                    heardAboutUs: heardAboutUs,
                    currentWakeTime: currentWakeTime,
                    desiredWakeTime: desiredWakeTime
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                chatView
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .onAppear {
            startConversation()
        }
    }

    var chatView: some View {
        VStack(spacing: 0) {
            // Header avec progression - style uniforme
            VStack(spacing: 16) {
                HStack {
                    Button(action: { isComplete = true }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 4)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color.snapOrange, Color.snapPink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * CGFloat(currentMessageIndex) / CGFloat(conversationFlow.count), height: 4)
                            .animation(.easeInOut(duration: 0.3), value: currentMessageIndex)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal)
            }
            .padding(.bottom, 20)

            // Messages avec scroll minimal
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Mascotte en haut (toujours visible)
                        Image("mascot_bienvenue")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.top, 20)

                        // Messages - style minimal
                        VStack(spacing: 16) {
                            ForEach(messages) { message in
                                if message.isFromCoco {
                                    // Message Coco - juste texte centré
                                    Text(message.text)
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 32)
                                        .id(message.id)
                                } else {
                                    // Réponse user - petit badge orange
                                    Text(message.text)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(Color.snapOrange.opacity(0.8))
                                        )
                                        .id(message.id)
                                }
                            }

                            if showTypingIndicator {
                                TypingIndicatorMinimal()
                                    .id("typing")
                            }
                        }
                    }
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        if let lastMessage = messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: showTypingIndicator) { _ in
                    withAnimation {
                        proxy.scrollTo("typing", anchor: .bottom)
                    }
                }
            }

            // Input area
            if showingInput {
                InputArea(
                    currentStep: conversationFlow[currentMessageIndex],
                    input: $currentInput,
                    userName: $userName,
                    selectedSnoozeTime: $selectedSnoozeTime,
                    biggestDream: $biggestDream,
                    commitment: $commitment,
                    currentWakeTime: $currentWakeTime,
                    desiredWakeTime: $desiredWakeTime,
                    selectedDays: $selectedDays,
                    onSend: handleUserResponse
                )
            }
        }
    }

    private func startConversation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showNextMessage()
        }
    }

    private func showNextMessage() {
        guard currentMessageIndex < conversationFlow.count else { return }

        let step = conversationFlow[currentMessageIndex]

        switch step {
        case .cocoMessage(let text, let mascot):
            showTypingIndicator = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showTypingIndicator = false
                let processedText = text.replacingOccurrences(of: "{name}", with: userName)
                messages.append(ChatMessage(text: processedText, isFromCoco: true, mascotImage: mascot))
                currentMessageIndex += 1

                // Auto-continue to next message if it's also from Coco
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showNextMessage()
                }
            }

        case .userInput(_):
            showingInput = true

        case .userChoice(_, _):
            showingInput = true

        case .userMultiChoice(_, _):
            showingInput = true

        case .userTimePicker(_):
            showingInput = true

        case .ctaButton(_, _):
            // Don't add message to chat - it will be displayed in InputArea
            showingInput = true

        case .transitionToVisual:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    transitionToV1 = true
                }
            }

        case .finish:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                finishOnboarding()
            }
        }
    }

    private func handleUserResponse() {
        let step = conversationFlow[currentMessageIndex]

        // Allow empty input for time pickers and CTA buttons
        if case .userTimePicker(_) = step {
            // Process time picker
        } else if case .ctaButton(_, _) = step {
            // CTA button doesn't need input
        } else {
            guard !currentInput.isEmpty else { return }
        }

        var userResponseText = currentInput
        var personalizedResponse: String? = nil

        switch step {
        case .userInput(let type):
            messages.append(ChatMessage(text: currentInput, isFromCoco: false))

            switch type {
            case .name:
                userName = currentInput
                // Response already in flow
            case .dream:
                biggestDream = currentInput
                personalizedResponse = getPersonalizedDreamResponse(currentInput)
            }

        case .userChoice(let type, _):
            messages.append(ChatMessage(text: currentInput, isFromCoco: false))

            switch type {
            case .age:
                userAge = currentInput
                personalizedResponse = getAgeResponse(currentInput)
            case .snoozeTime:
                selectedSnoozeTime = currentInput
                personalizedResponse = getSnoozeResponse(currentInput)
            case .guiltyFeeling:
                guiltyFeeling = currentInput
                personalizedResponse = getGuiltyResponse(currentInput)
            case .panicFeeling:
                panicFeeling = currentInput
                personalizedResponse = getPanicResponse(currentInput)
            case .alarmsCount:
                alarmsCount = currentInput
                personalizedResponse = getAlarmsCountResponse(currentInput)
            case .forgetTurnOff:
                forgetTurnOff = currentInput
                personalizedResponse = getForgetResponse(currentInput)
            case .selfThought:
                selfThought = currentInput
                personalizedResponse = getSelfThoughtResponse(currentInput)
            case .triesCount:
                triesCount = currentInput
                personalizedResponse = getTriesResponse(currentInput)
            case .dreamActivity:
                dreamActivity = currentInput
                personalizedResponse = getDreamActivityResponse(currentInput)
            case .lifeDifference:
                lifeDifference = currentInput
                personalizedResponse = getLifeDifferenceResponse(currentInput)
            case .futureFeeling:
                futureFeeling = currentInput
                personalizedResponse = getFutureFeelingResponse(currentInput)
            case .mission:
                selectedMission = currentInput
                personalizedResponse = getMissionResponse(currentInput)
            case .sound:
                selectedSound = currentInput
                personalizedResponse = "Great choice! 🎵"
            case .heardAboutUs:
                heardAboutUs = currentInput
                personalizedResponse = getHeardAboutResponse(currentInput)
            case .commitment:
                commitment = currentInput
                personalizedResponse = getCommitmentResponse(currentInput)
            case .days:
                break // Handled in userMultiChoice
            }

        case .userMultiChoice(let type, _):
            messages.append(ChatMessage(text: currentInput, isFromCoco: false))

            switch type {
            case .days:
                // currentInput contains comma-separated days
                let days = currentInput.components(separatedBy: ", ")
                selectedDays = Set(days)
                personalizedResponse = getDaysResponse(days.count)
            default:
                break
            }

        case .userTimePicker(let type):
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let timeString = formatter.string(from: type == .currentWakeTime ? currentWakeTime : desiredWakeTime)
            messages.append(ChatMessage(text: timeString, isFromCoco: false))

            if type == .desiredWakeTime {
                personalizedResponse = getDesiredWakeTimeResponse(desiredWakeTime)
            }

        case .ctaButton(_, _):
            // No user message needed - just proceed to next step
            break

        default:
            break
        }

        currentInput = ""
        showingInput = false
        currentMessageIndex += 1

        // Add personalized response before continuing
        if let response = personalizedResponse {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showTypingIndicator = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showTypingIndicator = false
                    self.messages.append(ChatMessage(text: response, isFromCoco: true, mascotImage: "mascot_guide"))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.showNextMessage()
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showNextMessage()
            }
        }
    }

    // MARK: - Personalized Responses

    private func getAgeResponse(_ age: String) -> String {
        switch age {
        case "Under 18": return "Young and ready to build great habits! 💪"
        case "18-24": return "Perfect age to master your mornings! 🌟"
        case "25-34": return "Great! You're in the prime time to transform your life 🚀"
        case "35-44": return "Awesome! It's never too late to change 💫"
        default: return "Experience + new habits = unstoppable! 🔥"
        }
    }

    private func getSnoozeResponse(_ time: String) -> String {
        if time.contains("Under 10") {
            return "Not too bad! But imagine having those extra minutes for yourself ⏰"
        } else if time.contains("10-20") {
            return "That's about 120 hours per year... time you could invest in yourself! 😮"
        } else if time.contains("20-30") {
            return "Wow, that's nearly 180 hours a year! Think what you could achieve with that time 🤯"
        } else if time.contains("30-45") {
            return "That's a lot of time lost... but we're going to change that together! 💪"
        } else {
            return "I totally get it. But this ends today. You're taking control! 🔥"
        }
    }

    private func getGuiltyResponse(_ feeling: String) -> String {
        if feeling == "Yes, every day" {
            return "That guilt is actually a sign you want to change. Let's turn it into action! 💪"
        } else if feeling == "Several times" {
            return "I hear you. That guilt means you care about yourself 💙"
        } else {
            return "Good! Less guilt, more action. Let's make it even better 🌟"
        }
    }

    private func getPanicResponse(_ feeling: String) -> String {
        // Calculate hours lost based on snooze time
        let hoursLost = calculateYearlyHoursLost(from: selectedSnoozeTime)
        let hoursMessage = hoursLost > 0 ? "\n\nListen to this... That snoozing costs you \(hoursLost) hours per year! That's time you could be using for yourself! 💪" : ""

        switch feeling {
        case "Stressed": return "That stress is draining your energy before the day even starts 😔\(hoursMessage)"
        case "Angry": return "I understand... waking up rushed ruins everything 😤\(hoursMessage)"
        case "Discouraged": return "That feeling won't last. We're fixing this together 💙\(hoursMessage)"
        default: return "Exactly! A bad morning can ruin an entire day. Not anymore! ✨\(hoursMessage)"
        }
    }

    private func calculateYearlyHoursLost(from snoozeTime: String) -> Int {
        let minutesPerDay: Int

        if snoozeTime.contains("Under 10") {
            minutesPerDay = 5
        } else if snoozeTime.contains("10-20") {
            minutesPerDay = 15
        } else if snoozeTime.contains("20-30") {
            minutesPerDay = 25
        } else if snoozeTime.contains("30-45") {
            minutesPerDay = 37
        } else if snoozeTime.contains("Over 45") || snoozeTime.contains("45-60") || snoozeTime.contains("Over an hour") {
            minutesPerDay = 50
        } else {
            return 0
        }

        let minutesPerYear = minutesPerDay * 365
        return minutesPerYear / 60
    }

    private func getAlarmsCountResponse(_ count: String) -> String {
        if count == "Only one" {
            return "Impressive! You're already ahead of most people 👏"
        } else if count == "2-3" {
            return "Classic strategy... but one powerful alarm is all you'll need 💪"
        } else if count.contains("4-6") {
            return "Whoa! That's alarm fatigue. One mission = one wake-up 🎯"
        } else if count.contains("More than 7") {
            return "That's alarm chaos! We're simplifying this right now 😅"
        } else {
            return "Let's bring some clarity to your mornings! 🌅"
        }
    }

    private func getForgetResponse(_ forget: String) -> String {
        if forget.contains("often") {
            return "That's autopilot mode. Your brain needs engagement, not just noise 🧠"
        } else if forget == "Sometimes" {
            return "That's your brain still half-asleep. A mission will wake it up! 💡"
        } else {
            return "Good awareness! A mission will make it even better ⚡"
        }
    }

    private func getSelfThoughtResponse(_ thought: String) -> String {
        return "Listen... that's NOT true. You just haven't had the right system yet 💙"
    }

    private func getTriesResponse(_ tries: String) -> String {
        if tries == "Never" {
            return "Then you're in for a transformation! 🌟"
        } else if tries.contains("1-2") {
            return "Third time's the charm! But this time it's different 💪"
        } else if tries.contains("3-5") {
            return "I know it's frustrating. But this time you have ME! 🐓"
        } else if tries.contains("Too many") {
            return "This is the LAST time you need to try. We got this! 🔥"
        } else {
            return "Well, now you have a coach who won't give up on you! 💙"
        }
    }

    private func getDreamActivityResponse(_ activity: String) -> String {
        switch activity {
        case "Exercise": return "Yes! Morning exercise = energy all day long! 💪"
        case "Have a real breakfast": return "Breakfast like a champion! Your body will thank you 🥞"
        case "Meditate or practice yoga": return "Inner peace before the chaos starts. Love it! 🧘"
        case "Work on my projects": return "That's when creativity peaks! Smart choice 🚀"
        default: return "Quality time is the best time! Beautiful goal 💙"
        }
    }

    private func getLifeDifferenceResponse(_ difference: String) -> String {
        return "Exactly! That's what we're building together 🎯"
    }

    private func getPersonalizedDreamResponse(_ dream: String) -> String {
        if dream == "I prefer not to say" {
            return "That's okay! Your goals are personal. What matters is you're here, ready to improve! 💙"
        } else {
            return "I love that! \(dream) is absolutely possible. Let's make it happen! ✨"
        }
    }

    private func getFutureFeelingResponse(_ feeling: String) -> String {
        return "That feeling? It's closer than you think! 🌟"
    }

    private func getMissionResponse(_ mission: String) -> String {
        switch mission {
        case "Push-ups": return "Beast mode activated! 15 seconds to wake up like a champion 💪"
        case "Sky Photo": return "Natural light = instant wake-up! Smart choice 📸"
        case "Make Your Bed": return "First win of the day = momentum! Love it 🛏️"
        case "Bible Verse": return "Spiritual + physical wake-up. Powerful combo! 🙏"
        case "Affirmation": return "Positive mindset from second one. Yes! ✨"
        case "Object Hunt": return "Get moving, brain activated! Perfect 🔍"
        default: return "Brain challenge first thing! You'll be sharp ⚡"
        }
    }

    private func getDaysResponse(_ count: Int) -> String {
        if count == 7 {
            return "Full commitment! That's how champions are made 🏆"
        } else if count >= 5 {
            return "Strong consistency! You're serious about this 💪"
        } else if count >= 3 {
            return "Good start! Building the habit step by step 🌟"
        } else {
            return "Every day counts! Let's make them powerful 🔥"
        }
    }

    private func getDesiredWakeTimeResponse(_ time: Date) -> String {
        let hour = Calendar.current.component(.hour, from: time)
        if hour < 6 {
            return "Wow! Early bird gets the worm 🐦 Respect!"
        } else if hour < 7 {
            return "Solid wake-up time! You'll own your mornings 🌅"
        } else if hour < 8 {
            return "Perfect timing! You'll have time for yourself before the world wakes up ⏰"
        } else {
            return "A fresh start! Let's make every morning count 🌞"
        }
    }

    private func getHeardAboutResponse(_ source: String) -> String {
        switch source {
        case "TikTok": return "TikTok sent you! Love it 📱"
        case "Instagram": return "Instagram knows what's up! 📸"
        case "Friend recommendation": return "Word of mouth is the best! Your friend knows what's up 🤝"
        case "App Store search": return "Great find! Smart search 🌟"
        case "YouTube": return "YouTube brought you here! Perfect 🎥"
        default: return "However you found us, I'm glad you're here! 💙"
        }
    }

    private func getCommitmentResponse(_ commitment: String) -> String {
        if commitment == "Determined" {
            return "THAT'S the energy! You're already winning 🔥"
        } else if commitment == "Seriously" {
            return "I can feel it! You're ready for this 💪"
        } else if commitment.contains("want to see") {
            return "Curiosity is the first step! Let me show you what's possible 🌟"
        } else {
            return "It's okay to be unsure. I believe in you enough for both of us! 💙"
        }
    }

    private func finishOnboarding() {
        // Save user data
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userAge, forKey: "userAge")
        UserDefaults.standard.set(selectedSnoozeTime, forKey: "selectedSnoozeTime")
        UserDefaults.standard.set(guiltyFeeling, forKey: "guiltyFeeling")
        UserDefaults.standard.set(currentWakeTime, forKey: "currentWakeTime")
        UserDefaults.standard.set(panicFeeling, forKey: "panicFeeling")
        UserDefaults.standard.set(alarmsCount, forKey: "alarmsCount")
        UserDefaults.standard.set(forgetTurnOff, forKey: "forgetTurnOff")
        UserDefaults.standard.set(selfThought, forKey: "selfThought")
        UserDefaults.standard.set(triesCount, forKey: "triesCount")
        UserDefaults.standard.set(dreamActivity, forKey: "dreamActivity")
        UserDefaults.standard.set(lifeDifference, forKey: "lifeDifference")
        UserDefaults.standard.set(biggestDream, forKey: "biggestDream")
        UserDefaults.standard.set(futureFeeling, forKey: "futureFeeling")
        UserDefaults.standard.set(selectedMission, forKey: "selectedMission")
        UserDefaults.standard.set(desiredWakeTime, forKey: "desiredWakeTime")
        UserDefaults.standard.set(selectedSound, forKey: "selectedSound")
        UserDefaults.standard.set(Array(selectedDays), forKey: "selectedDays")
        UserDefaults.standard.set(heardAboutUs, forKey: "heardAboutUs")
        UserDefaults.standard.set(commitment, forKey: "commitment")

        Task {
            await alarmManager.requestNotificationPermission()
        }

        withAnimation {
            isComplete = true
        }
    }
}

// MARK: - Models

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromCoco: Bool
    var mascotImage: String? = nil
}

enum ConversationStep {
    case cocoMessage(String, mascot: String)
    case userInput(InputType)
    case userChoice(ChoiceType, options: [String])
    case userMultiChoice(ChoiceType, options: [String])
    case userTimePicker(TimePickerType)
    case ctaButton(String, buttonText: String)
    case transitionToVisual
    case finish
}

enum InputType {
    case name
    case dream
}

enum ChoiceType {
    case age
    case snoozeTime
    case guiltyFeeling
    case panicFeeling
    case alarmsCount
    case forgetTurnOff
    case selfThought
    case triesCount
    case dreamActivity
    case lifeDifference
    case futureFeeling
    case mission
    case sound
    case days
    case heardAboutUs
    case commitment
}

enum TimePickerType {
    case currentWakeTime
    case desiredWakeTime
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage
    let userName: String
    @State private var appeared = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromCoco {
                // Coco's message (left side)
                if let mascotImage = message.mascotImage {
                    Image(mascotImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .scaleEffect(appeared ? 1 : 0.8)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .font(.faro(size: 16))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(20)
                        .cornerRadius(4, corners: [.bottomLeft])
                        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)

                    if message.mascotImage != nil {
                        Text("Coco")
                            .font(.faro(size: 11))
                            .foregroundColor(.gray)
                            .padding(.leading, 4)
                    }
                }
                .offset(x: appeared ? 0 : -20)
                .opacity(appeared ? 1 : 0)

                Spacer()
            } else {
                // User's message (right side)
                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.faro(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            LinearGradient(
                                colors: [Color.snapOrange, Color.snapOrange.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .cornerRadius(4, corners: [.bottomRight])
                        .shadow(color: Color.snapOrange.opacity(0.2), radius: 8, y: 2)

                    Text(userName.isEmpty ? "You" : userName)
                        .font(.faro(size: 11))
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
                .offset(x: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appeared = true
            }
        }
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image("mascot_guide")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(20)

            Spacer()
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Typing Indicator Minimal

struct TypingIndicatorMinimal: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.snapOrange.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .padding(.vertical, 12)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Input Area

struct InputArea: View {
    let currentStep: ConversationStep
    @Binding var input: String
    @Binding var userName: String
    @Binding var selectedSnoozeTime: String
    @Binding var biggestDream: String
    @Binding var commitment: String
    @Binding var currentWakeTime: Date
    @Binding var desiredWakeTime: Date
    @Binding var selectedDays: Set<String>
    let onSend: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            switch currentStep {
            case .userInput(let type):
                // Text input with enhanced design
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        TextField(placeholder(for: type), text: $input)
                            .font(.faro(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(24)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(input.isEmpty ? Color.clear : Color.snapOrange.opacity(0.3), lineWidth: 2)
                            )

                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            onSend()
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(input.isEmpty ? .gray.opacity(0.3) : Color.snapOrange)
                                .scaleEffect(input.isEmpty ? 1 : 1.1)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: input.isEmpty)
                        }
                        .disabled(input.isEmpty)
                    }

                    // Skip button for dream input
                    if type == .dream {
                        Button(action: {
                            input = "I prefer not to say"
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            onSend()
                        }) {
                            Text("Skip")
                                .font(.faro(size: 14))
                                .foregroundColor(.gray)
                                .underline()
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 16)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.snapLightBackground)

            case .userChoice(_, let options):
                // Choice buttons - NOT full width, aligned right like iMessage
                VStack(alignment: .trailing, spacing: 12) {
                    ForEach(Array(options.enumerated()), id: \.element) { index, option in
                        Button(action: {
                            input = option
                            // Haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            onSend()
                        }) {
                            HStack(spacing: 10) {
                                Text(option)
                                    .font(.faro(size: 16))
                                    .foregroundColor(.black)

                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.snapOrange.opacity(0.3))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
                        }
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05), value: options)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.snapLightBackground)

            case .userMultiChoice(_, let options):
                // Multi-choice buttons (toggleable) - vertical list (not full width)
                VStack(alignment: .trailing, spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            if selectedDays.contains(option) {
                                selectedDays.remove(option)
                            } else {
                                selectedDays.insert(option)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Text(option)
                                    .font(.faro(size: 16))
                                    .foregroundColor(selectedDays.contains(option) ? .white : .black)
                                if selectedDays.contains(option) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18))
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(selectedDays.contains(option) ? Color.snapOrange : Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(selectedDays.contains(option) ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }

                    Button(action: {
                        input = Array(selectedDays).joined(separator: ", ")
                        onSend()
                    }) {
                        Text("Continue")
                            .font(.faro(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 14)
                            .background(selectedDays.isEmpty ? Color.gray.opacity(0.3) : Color.snapOrange)
                            .cornerRadius(24)
                    }
                    .disabled(selectedDays.isEmpty)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.snapLightBackground)

            case .userTimePicker(let type):
                // Time picker
                VStack(spacing: 12) {
                    if type == .currentWakeTime {
                        DatePicker("", selection: $currentWakeTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                    } else {
                        DatePicker("", selection: $desiredWakeTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                    }

                    Button(action: onSend) {
                        Text("Continue")
                            .font(.faro(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(Color.snapOrange)
                            .cornerRadius(24)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 12)
                .background(Color.snapLightBackground)

            case .ctaButton(_, let buttonText):
                // Big CTA button - centered
                VStack(spacing: 16) {
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        onSend()
                    }) {
                        HStack(spacing: 12) {
                            Text(buttonText)
                                .font(.faroBold(size: 17))
                                .foregroundColor(.white)

                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.snapOrange)
                        .cornerRadius(30)
                        .shadow(color: Color.snapOrange.opacity(0.3), radius: 10, y: 5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.snapLightBackground)

            default:
                EmptyView()
            }
        }
    }

    private func placeholder(for type: InputType) -> String {
        switch type {
        case .name:
            return "Type your name..."
        case .dream:
            return "Share your biggest dream..."
        }
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - V1 Wrapper

struct OnboardingV1Wrapper: View {
    @Binding var isComplete: Bool
    let userName: String
    let userAge: String
    let snoozeTime: String
    let guiltyFeeling: String
    let panicFeeling: String
    let dreamActivity: String
    let alarmsCount: String
    let forgetTurnOff: String
    let lifeDifference: String
    let selfThought: String
    let triesCount: String
    let biggestDream: String
    let commitment: String
    let futureFeeling: String
    let heardAboutUs: String
    let currentWakeTime: Date
    let desiredWakeTime: Date

    var body: some View {
        OnboardingV1Bridge(
            isComplete: $isComplete,
            initialStep: 2, // Start at snoozeQuestionView (after name from V2)
            prefilledData: OnboardingPrefilledData(
                userName: userName,
                userAge: userAge,
                snoozeTime: snoozeTime,
                guiltyFeeling: guiltyFeeling,
                panicFeeling: panicFeeling,
                dreamActivity: dreamActivity,
                alarmsCount: alarmsCount,
                forgetTurnOff: forgetTurnOff,
                lifeDifference: lifeDifference,
                selfThought: selfThought,
                triesCount: triesCount,
                biggestDream: biggestDream,
                commitment: commitment,
                futureFeeling: futureFeeling,
                heardAboutUs: heardAboutUs,
                currentWakeTime: currentWakeTime,
                desiredWakeTime: desiredWakeTime
            )
        )
    }
}

struct OnboardingPrefilledData {
    let userName: String
    let userAge: String
    let snoozeTime: String
    let guiltyFeeling: String
    let panicFeeling: String
    let dreamActivity: String
    let alarmsCount: String
    let forgetTurnOff: String
    let lifeDifference: String
    let selfThought: String
    let triesCount: String
    let biggestDream: String
    let commitment: String
    let futureFeeling: String
    let heardAboutUs: String
    let currentWakeTime: Date
    let desiredWakeTime: Date
}

struct OnboardingV1Bridge: View {
    @Binding var isComplete: Bool
    let initialStep: Int
    let prefilledData: OnboardingPrefilledData

    var body: some View {
        ModifiedCompleteOnboardingView(
            isComplete: $isComplete,
            initialStep: initialStep,
            userName: prefilledData.userName,
            userAge: prefilledData.userAge,
            snoozeTime: prefilledData.snoozeTime,
            guiltyFeeling: prefilledData.guiltyFeeling,
            panicFeeling: prefilledData.panicFeeling,
            dreamActivity: prefilledData.dreamActivity,
            alarmsCount: prefilledData.alarmsCount,
            forgetTurnOff: prefilledData.forgetTurnOff,
            lifeDifference: prefilledData.lifeDifference,
            selfThought: prefilledData.selfThought,
            triesCount: prefilledData.triesCount,
            biggestDream: prefilledData.biggestDream,
            commitment: prefilledData.commitment,
            futureFeeling: prefilledData.futureFeeling,
            heardAboutUs: prefilledData.heardAboutUs,
            currentWakeTime: prefilledData.currentWakeTime
        )
    }
}

// Wrapper that uses CompleteOnboardingView with prefilled data
struct ModifiedCompleteOnboardingView: View {
    @Binding var isComplete: Bool
    let initialStep: Int
    let userName: String
    let userAge: String
    let snoozeTime: String
    let guiltyFeeling: String
    let panicFeeling: String
    let dreamActivity: String
    let alarmsCount: String
    let forgetTurnOff: String
    let lifeDifference: String
    let selfThought: String
    let triesCount: String
    let biggestDream: String
    let commitment: String
    let futureFeeling: String
    let heardAboutUs: String
    let currentWakeTime: Date

    var body: some View {
        CompleteOnboardingViewWithData(
            isComplete: $isComplete,
            initialStep: initialStep,
            userName: userName,
            userAge: userAge,
            snoozeTime: snoozeTime,
            guiltyFeeling: guiltyFeeling,
            panicFeeling: panicFeeling,
            dreamActivity: dreamActivity,
            alarmsCount: alarmsCount,
            forgetTurnOff: forgetTurnOff,
            lifeDifference: lifeDifference,
            selfThought: selfThought,
            triesCount: triesCount,
            biggestDream: biggestDream,
            commitment: commitment,
            futureFeeling: futureFeeling,
            heardAboutUs: heardAboutUs,
            currentWakeTime: currentWakeTime
        )
    }
}

struct CompleteOnboardingViewWithData: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var alarmManager = AlarmManager.shared
    @Binding var isComplete: Bool

    let initialStep: Int
    @State private var currentStep: Int

    // Pre-filled data from chat
    @State private var userName: String
    @State private var userAge: String
    @State private var snoozeTime: String
    @State private var guiltyFeeling: String
    @State private var panicFeeling: String
    @State private var dreamActivity: String
    @State private var alarmsCount: String
    @State private var forgetTurnOff: String
    @State private var lifeDifference: String
    @State private var selfThought: String
    @State private var triesCount: String
    @State private var biggestDream: String
    @State private var commitment: String
    @State private var futureFeeling: String
    @State private var heardAboutUs: String
    @State private var currentWakeTime: Date

    @State private var selectedMission = ""
    @State private var selectedSound = "Default"
    @State private var selectedDays: Set<String> = []
    @State private var loadingProgress = 0.0
    @State private var showTransformationItems = false
    @State private var desiredWakeTime = Date()
    @State private var showCamera = false
    @State private var wakeHistoryCard = ""
    @State private var userSignature = ""
    @State private var planCreationProgress = 0.0

    init(isComplete: Binding<Bool>, initialStep: Int, userName: String, userAge: String, snoozeTime: String, guiltyFeeling: String, panicFeeling: String, dreamActivity: String, alarmsCount: String, forgetTurnOff: String, lifeDifference: String, selfThought: String, triesCount: String, biggestDream: String, commitment: String, futureFeeling: String, heardAboutUs: String, currentWakeTime: Date) {
        self._isComplete = isComplete
        self.initialStep = initialStep
        self._currentStep = State(initialValue: initialStep)
        self._userName = State(initialValue: userName)
        self._userAge = State(initialValue: userAge)
        self._snoozeTime = State(initialValue: snoozeTime)
        self._guiltyFeeling = State(initialValue: guiltyFeeling)
        self._panicFeeling = State(initialValue: panicFeeling)
        self._dreamActivity = State(initialValue: dreamActivity)
        self._alarmsCount = State(initialValue: alarmsCount)
        self._forgetTurnOff = State(initialValue: forgetTurnOff)
        self._lifeDifference = State(initialValue: lifeDifference)
        self._selfThought = State(initialValue: selfThought)
        self._triesCount = State(initialValue: triesCount)
        self._biggestDream = State(initialValue: biggestDream)
        self._commitment = State(initialValue: commitment)
        self._futureFeeling = State(initialValue: futureFeeling)
        self._heardAboutUs = State(initialValue: heardAboutUs)
        self._currentWakeTime = State(initialValue: currentWakeTime)
    }

    var body: some View {
        CompleteOnboardingView(
            isComplete: $isComplete,
            initialStep: initialStep,
            prefilledUserName: userName,
            prefilledUserAge: userAge,
            prefilledSnoozeTime: snoozeTime,
            prefilledGuiltyFeeling: guiltyFeeling,
            prefilledPanicFeeling: panicFeeling,
            prefilledDreamActivity: dreamActivity,
            prefilledAlarmsCount: alarmsCount,
            prefilledForgetTurnOff: forgetTurnOff,
            prefilledLifeDifference: lifeDifference,
            prefilledSelfThought: selfThought,
            prefilledTriesCount: triesCount,
            prefilledBiggestDream: biggestDream,
            prefilledCommitment: commitment,
            prefilledFutureFeeling: futureFeeling,
            prefilledHeardAboutUs: heardAboutUs,
            prefilledCurrentWakeTime: currentWakeTime
        )
    }
}


// MARK: - Preview

#Preview {
    OnboardingV2View(isComplete: .constant(false))
}
