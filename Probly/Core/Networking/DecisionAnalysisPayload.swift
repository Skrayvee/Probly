//
//  DecisionAnalysisPayload.swift
//  Probly
//
//  Created by Skr Red on 27.09.2026.
//

import Foundation

struct DecisionAnalysisPayload: Encodable {
    let state: String
    let questions: [String: QuestionPayload]
    
    init (decision: Decision) {
        self.state = decision.state
        var jevQuestions: [String: QuestionPayload] = [:]
        for question in decision.questions {
            jevQuestions[question.id.uuidString] = QuestionPayload(question: question)
        }
        self.questions = jevQuestions
    }
}

struct QuestionPayload: Encodable {
    let instructions: String
    let criteria: QuestionCriteria
    
    init(question: Question) {
        self.instructions = question.instructions
        self.criteria = question.criteria
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case instructions
        case type
        case criteria
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(instructions, forKey: .instructions)
        
        switch criteria {
        case .choice(let rawOptions):
            var options: [String: String?] = [:]
            for option in rawOptions {
                options[option.title] = option.explanation
            }
            try container.encode("choice", forKey: .type)
            try container.encode(options, forKey: .criteria)
        case .score(let levels):
            try container.encode("score", forKey: .type)
            try container.encode(levels, forKey: .criteria)
        case .noul(let explanations):
            try container.encode("noul", forKey: .type)
            try container.encodeIfPresent(explanations, forKey: .criteria)
        }
    }
}
