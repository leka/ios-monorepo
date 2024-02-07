// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import SwiftUI

struct MainView: View {
    var body: some View {
        Text("Hello, AccountKit!")
            .onAppear {
                let professions = Professions.list
                for (index, profession) in professions.enumerated() {
                    print("index: \(index + 1)")
                    print("version: \(Professions.version)")
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
