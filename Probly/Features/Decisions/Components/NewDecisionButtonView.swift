//
//  NewDecisionButtonView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

struct NewDecisionButtonView: View {
    var body: some View {
        NavigationLink {
            DecisionEditorView()
        } label: {
            Label("Новый разбор", systemImage: "plus")
        }
        .buttonStyle(.glassProminent)
        .controlSize(.large)
    }
}

#Preview {
    NewDecisionButtonView()
}
