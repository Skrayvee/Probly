//
//  RootView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI
import SwiftData

struct RootView: View {
    var body: some View {
        Group {
            NavigationStack {
                DecisionsView()
            }
            .modelContainer(for: [Decision.self], inMemory: false)
        }
        .tint(Color("Accent"))
    }
}

#Preview {
    RootView()
}
