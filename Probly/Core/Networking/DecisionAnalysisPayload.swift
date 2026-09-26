//
//  DecisionAnalysisPayload.swift
//  Probly
//
//  Created by Skr Red on 27.09.2026.
//

import Foundation

struct DecisionAnalysisPayload: Encodable {
    let state: String
    let questions: [QuestionPayload]
    
    init (decision: Decision) {
        self.state = decision.state
        self.questions = decision.questions.map { question in QuestionPayload(question: question) }
    }
}

struct QuestionPayload: Encodable {
    let id: UUID
    let instructions: String
    let criteria: QuestionCriteria
    
    init(question: Question) {
        self.id = question.id
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
        
        try container.encode(id, forKey: .id)
        try container.encode(instructions, forKey: .instructions)
        
        switch criteria {
        case .choice(let options):
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
