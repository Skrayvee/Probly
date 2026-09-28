//
//  DecisionAPI.swift
//  Probly
//
//  Created by Skr Red on 28.09.2026.
//

import Foundation

struct DecisionAPI {
    let analysisURL: URL
    
    func analyze(_ payload: DecisionAnalysisPayload) async throws -> DecisionAnalysisResponse {
        var request = URLRequest(url: analysisURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw DecisionAPIError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw DecisionAPIError.httpError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(DecisionAnalysisResponse.self, from: data)
    }
}

enum DecisionAPIError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: String(localized: "Не удалось распознать ответ сервера.")
        case .httpError(let statusCode): String(localized: "Сервер вернул ошибку. Код: \(statusCode).")
        }
    }
}
