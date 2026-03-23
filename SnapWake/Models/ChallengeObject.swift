//
//  ChallengeObject.swift
//  SnapWake
//
//  Created by Josselin Biot on 07/03/2026.
//

import Foundation

struct ChallengeObject: Codable, Identifiable {
    let id: UUID
    let name: String
    let difficulty: Difficulty
    let keywords: [String] // Pour la reconnaissance d'image

    init(name: String, difficulty: Difficulty, keywords: [String]) {
        self.id = UUID()
        self.name = name
        self.difficulty = difficulty
        self.keywords = keywords
    }
}

// Base de données d'objets
class ChallengeDatabase {
    static let shared = ChallengeDatabase()

    let objects: [ChallengeObject] = [
        // Easy
        ChallengeObject(name: "a spoon", difficulty: .easy, keywords: ["spoon", "cutlery", "utensil"]),
        ChallengeObject(name: "a shoe", difficulty: .easy, keywords: ["shoe", "sneaker", "footwear"]),
        ChallengeObject(name: "a toothbrush", difficulty: .easy, keywords: ["toothbrush", "brush"]),
        ChallengeObject(name: "a mug", difficulty: .easy, keywords: ["mug", "cup", "coffee"]),
        ChallengeObject(name: "a pillow", difficulty: .easy, keywords: ["pillow", "cushion"]),
        ChallengeObject(name: "a door", difficulty: .easy, keywords: ["door"]),

        // Medium
        ChallengeObject(name: "a fruit", difficulty: .medium, keywords: ["fruit", "apple", "banana", "orange"]),
        ChallengeObject(name: "a plant", difficulty: .medium, keywords: ["plant", "flower", "leaf"]),
        ChallengeObject(name: "a book", difficulty: .medium, keywords: ["book", "novel"]),
        ChallengeObject(name: "yourself in a mirror", difficulty: .medium, keywords: ["mirror", "reflection", "person"]),
        ChallengeObject(name: "a window with daylight", difficulty: .medium, keywords: ["window", "glass"]),

        // Hard
        ChallengeObject(name: "something red", difficulty: .hard, keywords: ["red"]),
        ChallengeObject(name: "an animal", difficulty: .hard, keywords: ["dog", "cat", "pet", "animal"]),
        ChallengeObject(name: "another person", difficulty: .hard, keywords: ["person", "people", "human"]),
        ChallengeObject(name: "a tree outside", difficulty: .hard, keywords: ["tree", "outdoor"]),

        // Impossible
        ChallengeObject(name: "a bird", difficulty: .impossible, keywords: ["bird"]),
        ChallengeObject(name: "the sun", difficulty: .impossible, keywords: ["sun", "sky", "sunrise"]),
        ChallengeObject(name: "something beautiful", difficulty: .impossible, keywords: ["landscape", "flower", "art"])
    ]

    func randomObject(for difficulty: Difficulty) -> ChallengeObject {
        let filtered = objects.filter { $0.difficulty == difficulty }
        return filtered.randomElement() ?? objects[0]
    }
}
