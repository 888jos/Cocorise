//
//  Mission.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation
import SwiftUI

enum MissionType: String, Codable {
    case none = "none"
    case photo = "photo"
    case exercise = "exercise"
    case shake = "shake"
    case text = "text"
    case math = "math"
    case random = "random"
}

struct Mission: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var icon: String
    var gradient: [Color]
    var category: MissionCategory
    var type: MissionType
    var isNoMission: Bool
    var config: MissionConfig?

    init(name: String, description: String, icon: String, gradient: [Color], category: MissionCategory, type: MissionType = .none, isNoMission: Bool = false, config: MissionConfig? = nil) {
        self.name = name
        self.description = description
        self.icon = icon
        self.gradient = gradient
        self.category = category
        self.type = type
        self.isNoMission = isNoMission
        self.config = config
    }
}

// Mission Configuration
struct MissionConfig: Equatable {
    var duration: Int? // in seconds for exercises
    var count: Int? // for shake/items
    var selectedVerses: [String]? // for bible verses
    var selectedItems: [String]? // for object hunt
    var selectedMissions: [String]? // for random mission
    var selectedAffirmations: [String]? // for affirmation mission
}

// Bible Verses with full text
struct BibleVerse: Identifiable, Codable, Equatable {
    let id: String
    let reference: String
    let text: String

    init(reference: String, text: String) {
        self.id = reference
        self.reference = reference
        self.text = text
    }
}

// Affirmation with ID for selection
struct Affirmation: Identifiable, Codable, Equatable {
    let id: String
    let text: String

    init(text: String) {
        self.id = text
        self.text = text
    }
}

struct Affirmations {
    static let allAffirmations: [Affirmation] = [
        Affirmation(text: "I am capable of achieving great things today."),
        Affirmation(text: "I choose to make today amazing."),
        Affirmation(text: "I am grateful for this new day and all the opportunities it brings."),
        Affirmation(text: "I have the power to create positive change in my life."),
        Affirmation(text: "I am strong, focused, and ready to conquer my goals."),
        Affirmation(text: "Today I will be productive and make progress toward my dreams."),
        Affirmation(text: "I am in control of my thoughts, my actions, and my day."),
        Affirmation(text: "I radiate confidence, positivity, and energy."),
        Affirmation(text: "I am worthy of success and happiness."),
        Affirmation(text: "Every challenge I face today is an opportunity to grow stronger."),
        Affirmation(text: "I trust myself to make the right decisions."),
        Affirmation(text: "I am disciplined, motivated, and unstoppable."),
        Affirmation(text: "Today is full of endless possibilities."),
        Affirmation(text: "I choose to focus on what I can control and let go of what I cannot."),
        Affirmation(text: "I am becoming the best version of myself, one day at a time.")
    ]

    // Convenience property for backward compatibility
    static let affirmations = allAffirmations.map { $0.text }
}

struct BibleVerses {
    static let allVerses: [BibleVerse] = [
        BibleVerse(
            reference: "Jeremiah 29:11",
            text: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future."
        ),
        BibleVerse(
            reference: "Philippians 4:13",
            text: "I can do all things through Christ who strengthens me."
        ),
        BibleVerse(
            reference: "Psalm 23:1-3",
            text: "The Lord is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters. He restores my soul."
        ),
        BibleVerse(
            reference: "Proverbs 3:5-6",
            text: "Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight."
        ),
        BibleVerse(
            reference: "Romans 8:28",
            text: "And we know that in all things God works for the good of those who love him, who have been called according to his purpose."
        ),
        BibleVerse(
            reference: "Isaiah 41:10",
            text: "So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you; I will uphold you with my righteous right hand."
        ),
        BibleVerse(
            reference: "John 3:16",
            text: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life."
        ),
        BibleVerse(
            reference: "Matthew 6:33",
            text: "But seek first his kingdom and his righteousness, and all these things will be given to you as well."
        ),
        BibleVerse(
            reference: "Psalm 46:1",
            text: "God is our refuge and strength, an ever-present help in trouble."
        ),
        BibleVerse(
            reference: "2 Corinthians 12:9",
            text: "But he said to me, 'My grace is sufficient for you, for my power is made perfect in weakness.'"
        ),
        BibleVerse(
            reference: "Proverbs 16:3",
            text: "Commit to the Lord whatever you do, and he will establish your plans."
        ),
        BibleVerse(
            reference: "Joshua 1:9",
            text: "Have I not commanded you? Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go."
        ),
        BibleVerse(
            reference: "Romans 12:2",
            text: "Do not conform to the pattern of this world, but be transformed by the renewing of your mind. Then you will be able to test and approve what God's will is—his good, pleasing and perfect will."
        ),
        BibleVerse(
            reference: "Psalm 27:1",
            text: "The Lord is my light and my salvation—whom shall I fear? The Lord is the stronghold of my life—of whom shall I be afraid?"
        ),
        BibleVerse(
            reference: "Isaiah 40:31",
            text: "But those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint."
        )
    ]

    // Legacy support - just references
    static let popular = allVerses.map { $0.reference }
}

// Object Hunt Items with Emojis
struct HuntObject: Identifiable, Codable, Equatable {
    let id: String
    let emoji: String
    let name: String

    init(emoji: String, name: String) {
        self.id = name
        self.emoji = emoji
        self.name = name
    }
}

struct HuntObjects {
    static let allObjects: [HuntObject] = [
        // Bathroom (8)
        HuntObject(emoji: "🪥", name: "Toothbrush"),
        HuntObject(emoji: "🚿", name: "Shower"),
        HuntObject(emoji: "🚽", name: "Toilet"),
        HuntObject(emoji: "🪞", name: "Mirror"),
        HuntObject(emoji: "🧴", name: "Shampoo"),
        HuntObject(emoji: "🧻", name: "Toilet Paper"),
        HuntObject(emoji: "💧", name: "Running Faucet"),
        HuntObject(emoji: "🧼", name: "Soap"),

        // Kitchen (10)
        HuntObject(emoji: "☕️", name: "Coffee Mug"),
        HuntObject(emoji: "🥄", name: "Spoon"),
        HuntObject(emoji: "🍴", name: "Fork"),
        HuntObject(emoji: "🔪", name: "Knife"),
        HuntObject(emoji: "🍳", name: "Pan"),
        HuntObject(emoji: "🥤", name: "Glass"),
        HuntObject(emoji: "🍽️", name: "Plate"),
        HuntObject(emoji: "❄️", name: "Fridge"),
        HuntObject(emoji: "🍞", name: "Bread"),
        HuntObject(emoji: "🍎", name: "Fruit"),

        // Bedroom (6)
        HuntObject(emoji: "🛏️", name: "Bed"),
        HuntObject(emoji: "🛋️", name: "Pillow"),
        HuntObject(emoji: "⏰", name: "Clock"),
        HuntObject(emoji: "💡", name: "Lamp"),
        HuntObject(emoji: "📚", name: "Book"),
        HuntObject(emoji: "🪟", name: "Window"),

        // Personal Items (8)
        HuntObject(emoji: "👟", name: "Shoes"),
        HuntObject(emoji: "🔑", name: "Keys"),
        HuntObject(emoji: "💧", name: "Water Bottle"),
        HuntObject(emoji: "🎒", name: "Backpack"),
        HuntObject(emoji: "📱", name: "Phone Charger"),
        HuntObject(emoji: "🎧", name: "Headphones"),
        HuntObject(emoji: "👕", name: "Shirt"),
        HuntObject(emoji: "⌚️", name: "Watch"),

        // Living Room (6)
        HuntObject(emoji: "📺", name: "TV"),
        HuntObject(emoji: "🎮", name: "Remote Control"),
        HuntObject(emoji: "🪴", name: "Plant"),
        HuntObject(emoji: "🚪", name: "Door"),
        HuntObject(emoji: "🖼️", name: "Picture Frame"),
        HuntObject(emoji: "🕯️", name: "Candle"),

        // Office/Study (5)
        HuntObject(emoji: "✏️", name: "Pen"),
        HuntObject(emoji: "💻", name: "Laptop"),
        HuntObject(emoji: "🖱️", name: "Mouse"),
        HuntObject(emoji: "📓", name: "Notebook"),
        HuntObject(emoji: "🖨️", name: "Printer"),

        // Pets & Nature (4)
        HuntObject(emoji: "🐶", name: "Dog"),
        HuntObject(emoji: "🐱", name: "Cat"),
        HuntObject(emoji: "🌳", name: "Tree"),
        HuntObject(emoji: "🌺", name: "Flower"),

        // Misc (3)
        HuntObject(emoji: "🚗", name: "Car"),
        HuntObject(emoji: "🚲", name: "Bike"),
        HuntObject(emoji: "😊", name: "Your Smile")
    ]

    // Legacy items for backwards compatibility
    static let items = allObjects.map { $0.name }
}

enum MissionCategory: String, CaseIterable {
    case all = "All"
    case trending = "Trending"
    case easy = "Easy"
    case medium = "Medium"

    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .trending: return "flame"
        case .easy: return "leaf"
        case .medium: return "bolt"
        }
    }
}

class MissionsLibrary {
    static let shared = MissionsLibrary()

    let missions: [Mission] = [
        Mission(
            name: "No Mission",
            description: "Just a normal alarm — no mission",
            icon: "bell.fill",
            gradient: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
            category: .all,
            type: .none,
            isNoMission: true
        ),
        Mission(
            name: "Push Ups",
            description: "Video yourself doing push-ups",
            icon: "figure.strengthtraining.traditional",
            gradient: [Color.orange, Color.red],
            category: .trending,
            type: .exercise
        ),
        Mission(
            name: "Squats",
            description: "Video yourself doing squats",
            icon: "figure.run",
            gradient: [Color.orange, Color.red.opacity(0.8)],
            category: .easy,
            type: .exercise
        ),
        Mission(
            name: "Shake Phone",
            description: "Shake your phone 30 times",
            icon: "iphone.radiowaves.left.and.right",
            gradient: [Color.blue, Color.purple],
            category: .easy,
            type: .shake
        ),
        Mission(
            name: "Sky Photo",
            description: "Take a photo of the sky",
            icon: "cloud.sun.fill",
            gradient: [Color.cyan, Color.blue],
            category: .medium,
            type: .photo
        ),
        Mission(
            name: "Make Bed",
            description: "Take a photo of your made bed",
            icon: "bed.double.fill",
            gradient: [Color.purple, Color.pink],
            category: .easy,
            type: .photo
        ),
        Mission(
            name: "Object Hunt",
            description: "Find and photograph a random object",
            icon: "camera.viewfinder",
            gradient: [Color.teal, Color.green],
            category: .medium,
            type: .photo
        ),
        Mission(
            name: "Touch Grass",
            description: "Take a photo of the grass",
            icon: "leaf.fill",
            gradient: [Color.green, Color.mint],
            category: .easy,
            type: .photo
        ),
        Mission(
            name: "Bible Verse",
            description: "Read a bible verse out loud",
            icon: "book.fill",
            gradient: [Color.purple, Color.orange],
            category: .medium,
            type: .text
        ),
        Mission(
            name: "Affirmation",
            description: "Read an affirmation out loud",
            icon: "quote.bubble.fill",
            gradient: [Color.pink, Color.red],
            category: .easy,
            type: .text
        ),
        Mission(
            name: "Math Problem",
            description: "Solve math problems to wake up",
            icon: "function",
            gradient: [Color.indigo, Color.purple],
            category: .medium,
            type: .math
        ),
        Mission(
            name: "Random",
            description: "Surprise mission each morning",
            icon: "die.face.5.fill",
            gradient: [Color.cyan, Color.blue],
            category: .trending,
            type: .random
        )
    ]

    func missions(for category: MissionCategory) -> [Mission] {
        if category == .all {
            return missions
        }
        return missions.filter { $0.category == category }
    }
}
