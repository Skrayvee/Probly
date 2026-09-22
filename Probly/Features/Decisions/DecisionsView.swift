//
//  DecisionsView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

struct DecisionsView: View {
    var body: some View {
        List {}
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
