//
//  NewDecisionView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI
import SwiftData

struct DecisionEditorView: View {
    let decision: Decision?
    let onSave: (Decision) -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSaveErrorPresented = false
    @State private var saveErrorMessage = ""
    @State private var title = ""
    @State private var state = ""
    @State private var questions: [Question] = []
    
    init(decision: Decision? = nil, onSave: @escaping (Decision) -> Void) {
        self.decision = decision
        self.onSave = onSave
        _title = State(initialValue: decision?.title ?? "")
        _state = State(initialValue: decision?.state ?? "")
        _questions = State(initialValue: decision?.questions ?? [])
    }
    
    private func save() {
        var result = decision ?? Decision(title: title, state: state, questions: questions)
        result.title = title
        result.state = state
        result.questions = questions
        
        if decision == nil {
            modelContext.insert(result)
        }
        
        do {
            try modelContext.save()
            onSave(result)
            if decision != nil {
                dismiss()
            }
        } catch {
            modelContext.rollback()
            saveErrorMessage = error.localizedDescription
            isSaveErrorPresented = true
        }
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
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Сохранить") {
                    save()
                }
                    .buttonStyle(.glassProminent)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || questions.count == 0)
            }
        }
        .alert("Произошла ошибка", isPresented: $isSaveErrorPresented) {
            Button("ОК", role: .cancel) {
                isSaveErrorPresented = false
            }
        }
    }
}

#Preview {
//    DecisionEditorView()
}
