//
//  RootView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI
import SwiftData

enum Route: Hashable {
    case newDecision
    case decision(PersistentIdentifier)
}

struct RootView: View {
    @State private var path: [Route] = []
    
    var body: some View {
        Group {
            NavigationStack(path: $path) {
                DecisionsView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .newDecision:
                            DecisionEditorView { result in
                                path = [.decision(result.persistentModelID)]
                            }
                        case .decision(let id):
                            DecisionView(decisionID: id)
                        }
                    }
            }
            .modelContainer(for: [Decision.self], inMemory: false)
        }
        .tint(Color("Accent"))
    }
}

#Preview {
    RootView()
}
