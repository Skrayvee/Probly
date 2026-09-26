//
//  DecisionAnalysisResponse.swift
//  Probly
//
//  Created by Skr Red on 27.09.2026.
//

import Foundation

struct DecisionAnalysisResponse: Decodable {
    let answers: [QuestionAnswerResponse]
}

struct QuestionAnswerResponse: Decodable {
    let id: UUID
    let answer: QuestionAnswer
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case noul
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "choice": self.answer = .choice(try ChoiceAnswer(from: decoder))
        case "score": self.answer = .score(try ScoreAnswer(from: decoder))
        case "noul": self.answer = .noul(noul: try container.decode(Double.self, forKey: .noul))
        default: throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: String(localized: "Неизвестный тип ответа: \(type)"))
        }
    }
}
