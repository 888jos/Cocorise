//
//  CompleteOnboardingView.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import SwiftUI
import Lottie

struct CompleteOnboardingView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var alarmManager = AlarmManager.shared
    @Binding var isComplete: Bool

    var initialStep: Int = 0
    var prefilledUserName: String = ""
    var prefilledUserAge: String = ""
    var prefilledSnoozeTime: String = ""
    var prefilledGuiltyFeeling: String = ""
    var prefilledPanicFeeling: String = ""
    var prefilledDreamActivity: String = ""
    var prefilledAlarmsCount: String = ""
    var prefilledForgetTurnOff: String = ""
    var prefilledLifeDifference: String = ""
    var prefilledSelfThought: String = ""
    var prefilledTriesCount: String = ""
    var prefilledBiggestDream: String = ""
    var prefilledCommitment: String = ""
    var prefilledFutureFeeling: String = ""
    var prefilledHeardAboutUs: String = ""
    var prefilledCurrentWakeTime: Date = Date()

    @State var currentStep: Int

    // User info
    @State var userName: String
    @State var userAge: String

    // Emotional trigger questions
    @State var snoozeTime: String
    @State var guiltyFeeling: String
    @State var panicFeeling: String
    @State var dreamActivity: String
    @State var alarmsCount: String
    @State var forgetTurnOff: String
    @State var lifeDifference: String
    @State var selfThought: String
    @State var triesCount: String
    @State var biggestDream: String
    @State var commitment: String
    @State var futureFeeling: String

    @State var selectedMission = ""
    @State var selectedSound = "Default"
    @State var selectedDays: Set<String> = []
    @State var loadingProgress = 0.0
    @State var showTransformationItems = false

    @State var currentWakeTime: Date
    @State var desiredWakeTime = Date()
    @State var showCamera = false
    @State var wakeHistoryCard = ""
    @State var selectedCardIndex = 0
    @State var heardAboutUs: String
    @State var userSignature = ""
    @State var planCreationProgress = 0.0

    init(isComplete: Binding<Bool>, initialStep: Int = 0, prefilledUserName: String = "", prefilledUserAge: String = "", prefilledSnoozeTime: String = "", prefilledGuiltyFeeling: String = "", prefilledPanicFeeling: String = "", prefilledDreamActivity: String = "", prefilledAlarmsCount: String = "", prefilledForgetTurnOff: String = "", prefilledLifeDifference: String = "", prefilledSelfThought: String = "", prefilledTriesCount: String = "", prefilledBiggestDream: String = "", prefilledCommitment: String = "", prefilledFutureFeeling: String = "", prefilledHeardAboutUs: String = "", prefilledCurrentWakeTime: Date = Date()) {
        self._isComplete = isComplete
        self.initialStep = initialStep
        self.prefilledUserName = prefilledUserName
        self.prefilledUserAge = prefilledUserAge
        self.prefilledSnoozeTime = prefilledSnoozeTime
        self.prefilledGuiltyFeeling = prefilledGuiltyFeeling
        self.prefilledPanicFeeling = prefilledPanicFeeling
        self.prefilledDreamActivity = prefilledDreamActivity
        self.prefilledAlarmsCount = prefilledAlarmsCount
        self.prefilledForgetTurnOff = prefilledForgetTurnOff
        self.prefilledLifeDifference = prefilledLifeDifference
        self.prefilledSelfThought = prefilledSelfThought
        self.prefilledTriesCount = prefilledTriesCount
        self.prefilledBiggestDream = prefilledBiggestDream
        self.prefilledCommitment = prefilledCommitment
        self.prefilledFutureFeeling = prefilledFutureFeeling
        self.prefilledHeardAboutUs = prefilledHeardAboutUs
        self.prefilledCurrentWakeTime = prefilledCurrentWakeTime

        self._currentStep = State(initialValue: initialStep)
        self._userName = State(initialValue: prefilledUserName)
        self._userAge = State(initialValue: prefilledUserAge)
        self._snoozeTime = State(initialValue: prefilledSnoozeTime)
        self._guiltyFeeling = State(initialValue: prefilledGuiltyFeeling)
        self._panicFeeling = State(initialValue: prefilledPanicFeeling)
        self._dreamActivity = State(initialValue: prefilledDreamActivity)
        self._alarmsCount = State(initialValue: prefilledAlarmsCount)
        self._forgetTurnOff = State(initialValue: prefilledForgetTurnOff)
        self._lifeDifference = State(initialValue: prefilledLifeDifference)
        self._selfThought = State(initialValue: prefilledSelfThought)
        self._triesCount = State(initialValue: prefilledTriesCount)
        self._biggestDream = State(initialValue: prefilledBiggestDream)
        self._commitment = State(initialValue: prefilledCommitment)
        self._futureFeeling = State(initialValue: prefilledFutureFeeling)
        self._currentWakeTime = State(initialValue: prefilledCurrentWakeTime)
        self._heardAboutUs = State(initialValue: prefilledHeardAboutUs)
    }

    var missionExplanations: [String: String] {
        [
            "Push-ups": "Push-ups immediately activate your cardiovascular system and increase your blood flow, making it impossible to go back to bed.",
            "Sky Photo": "Going outside and seeing natural light resets your biological clock and wakes you up instantly.",
            "Make Your Bed": "Completing this first task creates positive momentum and psychologically prevents you from going back to bed.",
            "Bible Verse": "Reciting aloud engages your brain, memory, and spirituality, putting you in a state of mental alertness.",
            "Affirmation": "Speaking positive affirmations aloud stimulates your brain and programs your mindset for the day.",
            "Object Hunt": "Moving around your house and searching for an object activates your body and brain simultaneously.",
            "Walk": "Walking forces your body to move, increases your body temperature, and wakes you up naturally.",
            "Math Problem": "Solving a mental calculation activates your cognitive functions and brings your brain out of sleep mode."
        ]
    }

    var body: some View {
        ZStack {
            Color.snapLightBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with back button and progress
                header

                content
            }
        }
    }

    var header: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                if currentStep > 0 && currentStep < 22 {
                    Button(action: {
                        withAnimation {
                            currentStep = max(0, currentStep - 1)
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 36, height: 36)

                            Image(systemName: "chevron.left")
                                .font(.faroBold(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.leading, 16)
                }

                Spacer()
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 3)

                    Rectangle()
                        .fill(Color.snapOrange)
                        .frame(width: geometry.size.width * progressPercentage, height: 3)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .frame(height: 3)
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }

    var progressPercentage: CGFloat {
        // Total steps in onboarding (0-38)
        let totalSteps: CGFloat = 38
        return min(CGFloat(currentStep) / totalSteps, 1.0)
    }

    @ViewBuilder
    var content: some View {
        switch currentStep {
        // NOUVELLE SECTION: User Info
        case 0: nameQuestionView // First name
        case 1: ageQuestionView // Age

        // PARTIE 1: Questions émotionnelles d'origine
        case 2: snoozeQuestionView // Q1: Temps de snooze
        case 3: guiltyFeelingView // Q2: Culpabilité
        case 4: currentWakeTimeView // 🕐 Heure de lever actuelle
        case 5: reassuranceView1 // 🎯 Reassurance: You're not alone
        case 6: panicFeelingView // Q3: Panique/retard
        case 7: painAmplificationView // 🎯 Graphic: Temps perdu visualisé
        case 8: alarmsCountView // Q5: Nombre d'alarmes
        case 9: quoteView1 // 🎯 Quote: "The secret of getting ahead..."
        case 10: forgetTurnOffView // Q6: Oublier d'avoir éteint
        case 11: selfThoughtView // Q8: Pensées négatives
        case 12: empathyView // 🎯 Reassurance: On comprend
        case 13: triesCountView // Q9: Tentatives échouées
        case 14: transformationGraphicView // 🎯 Graphic: Avant/Après
        case 15: dreamActivityView // Q4: Activité de rêve
        case 16: quoteView2 // 🎯 Quote: "Your future is created..."
        case 17: lifeDifferenceView // Q7: Vie différente
        case 18: biggestDreamView // Q10: Plus grand rêve
        case 19: visionBoardView // 🎯 Graphic: Vision board
        case 20: futureFeelingView // Q12: Sentiment futur
        case 21: successStoriesView // 🎯 Reassurance: Success stories

        // PARTIE 2: Nouveau flow d'action
        case 22: missionSelectionView // Choix mission
        case 23: missionCongratulationView // Félicitation mission
        case 24: letsTryItNowView // Let's try it now
        case 25: missionCameraView // Démo caméra
        case 26: ratingWithSocialProofView // Rating avec social proof
        case 27: stayOnTrackNotificationView // Stay on track + notification
        case 28: requestTrackingView // Request tracking
        case 29: desiredWakeTimeView // Ideal wake up time
        case 30: soundSelectionView // Choix son alarme
        case 31: daysSelectionView // Jours où l'alarme sonne
        case 32: wakeHistoryCardView // Choose your wake history card
        case 33: heardAboutUsView // Où avez-vous entendu parler de nous
        case 34: quoteWinTheMorningView // Quote: "If you win the morning..."
        case 35: readyToBecomeView // Ready to become a morning person
        case 36: signatureCommitmentView // Make the commitment - Signature
        case 37: planCreationView // Création du plan 0-100%
        case 38: finishView // Paywall
        default: finishView
        }
    }
}

#Preview {
    CompleteOnboardingView(isComplete: .constant(false))
}
