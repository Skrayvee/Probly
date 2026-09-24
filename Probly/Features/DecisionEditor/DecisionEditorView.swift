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
    @State private var questions: [Question] = []
    
    init(decision: Decision? = nil) {
        self.decision = decision
        _title = State(initialValue: decision?.title ?? "")
        _state = State(initialValue: decision?.state ?? "")
        _questions = State(initialValue: decision?.questions ?? [])
    }
    
    private func saveQuestion(_ question: Question) {
        if let index = questions.firstIndex(where: { $0.id == question.id }) {
            questions[index] = question
        } else {
            questions.append(question)
        }
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
                ForEach(questions) { question in
                    NavigationLink {
                        QuestionEditorView(question: question, onSave: saveQuestion)
                    } label: {
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
                .onDelete { offsets in
                    questions.remove(atOffsets: offsets)
                }
                
                NavigationLink {
                    QuestionEditorView(onSave: saveQuestion)
                } label: {
                    Label("Добавить вопрос", systemImage: "plus")
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
                .navigationLinkIndicatorVisibility(.hidden)
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
