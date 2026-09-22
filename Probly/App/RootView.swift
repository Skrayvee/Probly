//
//  RootView.swift
//  Probly
//
//  Created by Skr Red on 22.09.2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        Group {
            NavigationStack {
                DecisionsView()
            }
        }
        .tint(Color("Accent"))
    }
}

#Preview {
    RootView()
}
