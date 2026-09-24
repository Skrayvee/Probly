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
    
    @Query private var decisions: [Decision]
    
    init(decisionID: PersistentIdentifier) {
        self.decisionID = decisionID
        
        _decisions = Query(filter: #Predicate<Decision> { decision in
            decision.persistentModelID == decisionID
        })
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
                        }
                    }
                }
                .navigationTitle(decision.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            DecisionEditorView(decision: decision, onSave: {_ in })
                        } label: {
                            Label("Редактировать", systemImage: "square.and.pencil")
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
