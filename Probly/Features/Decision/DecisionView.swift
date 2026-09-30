//
//  DecisionView.swift
//  Probly
//
//  Created by Skr Red on 24.09.2026.
//

import SwiftUI
import SwiftData

struct DecisionView: View {
    let decisionID: PersistentIdentifier
    let api = DecisionAPI()
    
    @Environment(\.modelContext) private var modelContext
    @Query private var decisions: [Decision]
    @State private var isAnalyzing = false
    @State private var isAnalyzeErrorShown = false
    @State private var analyzeError = ""
    
    private var canAnalyze: Bool {
        guard let decision = decisions.first else { return false }
        guard let analyzedAt = decision.analyzedAt else { return true }
        guard let editedAt = decision.editedAt else { return false }
        
        return editedAt > analyzedAt
    }
    
    init(decisionID: PersistentIdentifier) {
        self.decisionID = decisionID
        
        _decisions = Query(filter: #Predicate<Decision> { decision in
            decision.persistentModelID == decisionID
        })
    }
    
    func analyze() async throws {
        guard let decision = decisions.first else { return }
        let payload = DecisionAnalysisPayload(decision: decision)
        let response = try await api.analyze(payload)
        
        for (key, result) in response.answers {
            guard let questionID = UUID(uuidString: key) else {
                throw DecisionAPIError.invalidResponse
            }
            
            if let index = decision.questions.firstIndex(where: {$0.id == questionID}) {
                decision.questions[index].answer = result.answer
            }
        }
        
        decision.analyzedAt = .now
        try modelContext.save()
    }
    
    var body: some View {
        Group {
            if let decision = decisions.first {
                List {
                    VStack(alignment: .leading) {
                        Text("Моя ситуация")
                            .font(.headline)
                        Text(decision.state)
                            .foregroundStyle(.secondary)
                    }
                    
                    Section(header: Text("Ответы"), footer: Text("Ответы — оценки модели.\nОкончательное решение остаётся за вами")) {
                        ForEach(decision.questions) {question in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(question.instructions)
                                    Spacer()
                                    Group {
                                        switch question.criteria {
                                        case .choice(let options): Text("\(options.count) вариантов")
                                        case .score(let levels): Text("\(levels.count) уровней шкалы")
                                        case .noul: Text(question.type.title)
                                        }
                                    }
                                    .foregroundStyle(.secondary)
                                }
                                Group {
                                    switch question.answer {
                                    case .noul(let noul):
                                        let percent = Int((noul * 100).rounded())
                                        Text("Да — \(percent)% · Нет — \(100 - percent)%")
                                    case .score(let score):
                                        if let maxProbability = score.probabilities.max(by: { $0.value < $1.value }) {
                                            let probability = Int(maxProbability.value * 100)
                                            if let title = score.legend?[maxProbability.key] {
                                                Text("\(title) · \(probability)%")
                                            } else {
                                                Text("\(probability)%")
                                            }
                                        }
                                    case .choice(let choice):
                                        if let probability = choice.probabilities[choice.choice]?.rounded() {
                                            Text("\(choice.choice) — \(Int(probability * 100))%")
                                        } else {
                                            Text(choice.choice)
                                        }
                                    case nil: EmptyView()
                                    }
                                }
                                .foregroundStyle(.accent)
                            }
                        }
                    }
                }
                .navigationTitle(decision.title)
                .alert("Ошибка", isPresented: $isAnalyzeErrorShown) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(analyzeError)
                }
                .toolbar {
                    if !decisions.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                DecisionEditorView(decision: decision, onSave: {_ in })
                            } label: {
                                Label("Редактировать", systemImage: "square.and.pencil")
                            }
                            .disabled(isAnalyzing)
                        }
                        if canAnalyze {
                            ToolbarItem(placement: .bottomBar) {
                                Button {
                                    guard !isAnalyzing else { return }
                                    isAnalyzing = true
                                    
                                    Task {
                                        defer { isAnalyzing = false }
                                        
                                        do {
                                            try await analyze()
                                        } catch {
                                            isAnalyzeErrorShown = true
                                            analyzeError = error.localizedDescription
                                        }
                                    }
                                } label: {
                                    HStack {
                                        if isAnalyzing {
                                            ProgressView()
                                                .tint(.primary)
                                                .colorInvert()
                                        }
                                        
                                        Text(isAnalyzing ? "Получение..." : decision.analyzedAt != nil ? "Обновить ответы" : "Получить ответы")
                                    }
                                }
                                .buttonStyle(.glassProminent)
                                .disabled(isAnalyzing)
                            }
                        }
                    }
                }
            } else if _decisions.fetchError != nil {
                ContentUnavailableView("Не удалось загрузить разбор", systemImage: "exclamationmark.triangle")
            } else {
                ContentUnavailableView("Разбор не найден", systemImage: "doc.text")
            }
        }
    }
}

#Preview {
    //    DecisionView()
}
