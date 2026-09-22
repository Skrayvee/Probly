//
//  Decision.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import Foundation
import SwiftData

enum QuestionType: Codable {
    case choice
    case noul
    case score
    
    var title: String {
        switch self {
        case .choice:
            return String(localized: "Варианты")
        case .noul:
            return String(localized: "Да / Нет")
        case .score:
            return String(localized: "Шкала")
        }
    }
}

struct ChoiceOption: Codable {
    var title: String
    var explanation: String? = nil
}

struct NoulCriteria: Codable {
    var trueExplanation: String? = nil
    var falseExplanation: String? = nil
    
    enum CodingKeys: String,  CodingKey {
        case trueExplanation = "true"
        case falseExplanation = "false"
    }
}

enum QuestionCriteria: Codable {
    case choice([ChoiceOption])
    case noul(NoulCriteria?)
    case score([String])
}

struct Question: Codable, Identifiable {
    var id: UUID
    var instructions: String
    var criteria: QuestionCriteria
    
    var type: QuestionType {
        switch criteria {
        case .choice: .choice
        case .noul: .noul
        case .score: .score
        }
    }
    
    init(instructions: String, criteria: QuestionCriteria) {
        self.id = UUID()
        self.instructions = instructions
        self.criteria = criteria
    }
}

@Model
class Decision {
    var title: String
    var state: String
    var questions: [Question]
    private(set) var createdAt: Date
    
    init(title: String, state: String) {
        self.title = title
        self.state = state
        self.questions = []
        self.createdAt = .now
    }
}
