//
//  DecisionsView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI
import SwiftData

struct DecisionsView: View {
    @Query(sort: \Decision.createdAt, order: .reverse) private var decisions: [Decision]
    
    var body: some View {
        Group {
            if decisions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "circle.grid.2x2.topleft.checkmark.filled")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("С чего начнём?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Опишите свою ситуацию и добавьте вопросы. Разберёмся с ними по порядку.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Новый разбор", systemImage: "plus") {}
                        .labelStyle(.titleAndIcon)
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)
                    Text("Или нажмите + в правом нижнем углу")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else {
                List {}
            }
        }
        .navigationTitle("Разборы")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarSpacer(placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Button("Новый разбор", systemImage: "plus") {}
                    .labelStyle(.titleAndIcon)
                    .buttonStyle(.glassProminent)
                    .controlSize(.large)
            }
        }
    }
}

#Preview {
    DecisionsView()
}
