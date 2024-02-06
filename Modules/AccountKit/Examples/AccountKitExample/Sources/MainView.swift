// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import SwiftUI

struct MainView: View {
    var body: some View {
        Text("Hello, AccountKit!")
            .onAppear {
                let professions = Professions()
                for profession in professions.list {
                    print("version: \(professions.version)")
                    print("id: \(profession.id)")
                    print("name: \(profession.name)")
                    print("description: \(profession.description)")
                }
            }
    }
}

#Preview {
    MainView()
}
