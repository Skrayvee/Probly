//
//  QuestionAnswer.swift
//  Probly
//
//  Created by Skr Red on 27.09.2026.
//

import Foundation

struct ChoiceAnswer: Codable {
    let choice: String
    let probabilities: [String: Double]
    let confidence: Double
}

struct ScoreAnswer: Codable {
    let score: Double
    let probabilities: [String: Double]
    let confidence: Double
    let legend: [String: String]
}

enum QuestionAnswer: Codable {
    case choice(ChoiceAnswer)
    case score(ScoreAnswer)
    case noul(noul: Double)
}
