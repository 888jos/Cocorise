//
//  MathProblem.swift
//  SnapWake
//
//  Modèle partagé pour les problèmes mathématiques
//

import Foundation

struct MathProblem {
    let question: String
    let answer: Int

    static func random(difficulty: Difficulty? = nil) -> MathProblem {
        let type = Int.random(in: 0...3)

        switch type {
        case 0: // Addition
            let a = Int.random(in: 10...99)
            let b = Int.random(in: 10...99)
            return MathProblem(question: "\(a) + \(b)", answer: a + b)

        case 1: // Subtraction
            let a = Int.random(in: 50...99)
            let b = Int.random(in: 10...a)
            return MathProblem(question: "\(a) - \(b)", answer: a - b)

        case 2: // Multiplication
            let a = Int.random(in: 5...15)
            let b = Int.random(in: 5...15)
            return MathProblem(question: "\(a) × \(b)", answer: a * b)

        default: // Division
            let b = Int.random(in: 5...12)
            let answer = Int.random(in: 5...15)
            let a = b * answer
            return MathProblem(question: "\(a) ÷ \(b)", answer: answer)
        }
    }
}
