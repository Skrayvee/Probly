//
//  QuestionEditorView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

private struct ChoiceDraft: Identifiable {
    let id = UUID()
    var title = ""
    var explanation = ""
}

private struct ScoreDraft: Identifiable {
    let id = UUID()
    var text = ""
}

struct QuestionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Question) -> Void
    let question: Question?
    @State private var instructions = ""
    @State private var type: QuestionType = .choice
    @State private var choiceCriteria: [ChoiceDraft] = [ChoiceDraft()]
    @State private var scoreCriteria: [ScoreDraft] = [ScoreDraft(), ScoreDraft()]
    @State private var trueExplanation = ""
    @State private var falseExplanation = ""
    
    init(question: Question? = nil, onSave: @escaping (Question) -> Void) {
        self.question = question
        self.onSave = onSave
        _instructions = State(initialValue: question?.instructions ?? "")
        _type = State(initialValue: question?.type ?? .choice)
        
        if let question {
            switch question.criteria {
            case .choice(let options):
                _choiceCriteria = State(initialValue: options.map { option in ChoiceDraft(title: option.title, explanation: option.explanation ?? "") })
            case .score(let levels):
                _scoreCriteria = State(initialValue: levels.map { option in ScoreDraft(text: option) })
            case .noul(let explanations):
                _trueExplanation = State(initialValue: explanations?.trueExplanation ?? "")
                _falseExplanation = State(initialValue: explanations?.falseExplanation ?? "")
            }
        }
    }
    
    private func save() {
        let criteria: QuestionCriteria = switch type {
        case .choice: .choice(choiceCriteria.map {option in ChoiceOption(title: option.title, explanation: option.explanation.isEmpty ? nil : option.explanation)})
        case .score: .score(scoreCriteria.map {level in level.text})
        case .noul: .noul(NoulCriteria(
            trueExplanation: trueExplanation.isEmpty ? nil : trueExplanation,
            falseExplanation: falseExplanation.isEmpty ? nil : falseExplanation
        ))
        }
        
        var result = question ?? Question(instructions: instructions, criteria: criteria)
        result.instructions = instructions
        result.criteria = criteria

        
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
                Section(header: Text("Варианты"), footer: Text("Не более 255 вариантов")) {
                    ForEach($choiceCriteria) {$option in
                        VStack {
                            TextField("Название варианта", text: $option.title)
                                .font(.title3)
                                .fontWeight(.semibold)
                            TextField("Пояснение (необязательно)", text: $option.explanation, axis: .vertical)
                        }
                        .deleteDisabled(choiceCriteria.count <= 1)
                    }
                    .onDelete {offsets in
                        choiceCriteria.remove(atOffsets: offsets)
                    }
                    if scoreCriteria.count < 255 {
                        Button("Добавить вариант", systemImage: "plus") {
                            choiceCriteria.append(ChoiceDraft())
                        }
                    }
                }
            } else if type == .score {
                Section(header: Text("Уровни шкалы"), footer: Text("Не менее 2 и не более 10")) {
                    ForEach($scoreCriteria) { $option in
                        if let index = scoreCriteria.firstIndex(where: {$0.id == option.id}) {
                            HStack {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                                    .frame(width: 28, height: 28)
                                TextField("Описание уровня", text: $option.text)
                                    .alignmentGuide(.listRowSeparatorLeading) {$0[.leading]}
                            }
                            .deleteDisabled(scoreCriteria.count <= 2)
                        }
                    }
                    .onDelete { offsets in
                        scoreCriteria.remove(atOffsets: offsets)
                    }
                    if scoreCriteria.count < 10 {
                        Button("Добавить уровень", systemImage: "plus") {
                            scoreCriteria.append(ScoreDraft())
                        }
                    }
                }
            } else if type == .noul {
                Section(header: Text("Пояснения"), footer: Text("Пояснения являются необязательными, вы можете оставиь их пустыми")) {
                    VStack(alignment: .leading) {
                        Text("Да")
                            .font(.title3.weight(.semibold))
                        TextField("Что означает «Да» в этом вопросе?", text: $trueExplanation, axis: .vertical)
                    }
                    VStack(alignment: .leading) {
                        Text("Нет")
                            .font(.title3.weight(.semibold))
                        TextField("Что означает «Нет» в этом вопросе?", text: $falseExplanation, axis: .vertical)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
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
