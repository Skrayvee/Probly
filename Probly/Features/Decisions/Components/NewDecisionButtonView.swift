//
//  NewDecisionButtonView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

struct NewDecisionButtonView: View {
    var body: some View {
        NavigationLink(value: Route.newDecision) {
            Label("Новый разбор", systemImage: "plus")
        }
        .controlSize(.large)
//        .buttonStyle(.glass)
    }
}

#Preview {
    NewDecisionButtonView()
}
