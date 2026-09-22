//
//  QuestionEditorView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

struct QuestionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Question) -> Void
    let question: Question?
    @State private var instructions = ""
    @State private var type: QuestionType = .choice
    
    init(question: Question? = nil, onSave: @escaping (Question) -> Void) {
        self.question = question
        self.onSave = onSave
        _instructions = State(initialValue: question?.instructions ?? "")
        _type = State(initialValue: question?.type ?? .choice)
    }
    
    private func save() {
        let emptyCriteria: QuestionCriteria = switch type {
        case .choice: .choice([])
        case .score: .score([])
        case .noul: .noul(nil)
        }
        
        var result = question ?? Question(instructions: instructions, criteria: emptyCriteria)
        result.instructions = instructions
        
        if result.type != type {
            result.criteria = emptyCriteria
        }
        
        onSave(result)
        dismiss()
    }
    
    var body: some View {
        List {
            Section(header: Text("Вопрос")) {
                TextField("Как провести выходной?", text: $instructions)
            }
            Section(header: Text("Формат ответа")) {
                Picker("Формат ответа", selection: $type) {
                    ForEach(QuestionType.allCases, id: \.self) { questionType in
                        Text(questionType.title)
                            .tag(questionType)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(.all, 0)
            }
            if type == .choice {
                Section(header: Text("Варианты")) {
                    Button("Добавить вариант", systemImage: "plus") {}
                }
            } else if type == .score {
                Section(header: Text("Уровни шкалы")) {
                    Button("Добавить уровень", systemImage: "plus") {}
                }
            } else if type == .noul {
                Section(header: Text("Пояснения"), footer: Text("Пояснения являются необязательными, вы можете оставиь их пустыми")) {
                    
                }
            }
        }
        .animation(.easeInOut(duration: 0.15), value: type)
        .navigationTitle(question == nil ? "Новый вопрос" : "Изменить вопрос")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Сохранить") {
                    save()
                }
                .disabled(instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}

#Preview {
    //    QuestionEditorView()
}
