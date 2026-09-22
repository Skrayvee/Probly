//
//  NewDecisionView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

struct DecisionEditorView: View {
    let decision: Decision?
    
    @State private var title = ""
    @State private var state = ""
    
    init(decision: Decision? = nil) {
        self.decision = decision
        _title = State(initialValue: decision?.title ?? "")
        _state = State(initialValue: decision?.state ?? "")
    }
    
    var body: some View {
        List {
            Section(header: Text("Название")) {
                TextField("Планы на выходные", text: $title)
            }
            Section(header: Text("Моя ситуация"), footer: Text("Эта ситуация учитывается во всех вопросах")) {
                TextField("Неделя была напряжённой\nХочу отдохнуть и провести время с другом\n\nБюджет — 2 000 ₽\nВ воскресенье обещают хорошую погоду", text: $state, axis: .vertical)
                    .lineLimit(6...12)
            }
            Section(header: Text("Вопросы")) {
                Button("Добавить вопрос", systemImage: "plus") {}
            }
        }
        .navigationTitle(decision == nil ? "Новый разбор" : "Изменить разбор")
        .navigationBarTitleDisplayMode(.inline)
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    DecisionEditorView()
}
