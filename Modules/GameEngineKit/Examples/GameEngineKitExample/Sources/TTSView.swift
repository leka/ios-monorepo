// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TTSView: View {
    var body: some View {
        VStack(spacing: 50) {
            HStack(spacing: 20) {
                Button("Choice 1") {
                    print("Choice 1")
                }
                .tint(.red)
                .buttonStyle(.borderedProminent)

                Button("Choice 2") {
                    print("Choice 2")
                }
                .tint(.yellow)
                .buttonStyle(.borderedProminent)

                Button("Choice 3") {
                    print("Choice 3")
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
            }

            HStack(spacing: 20) {
                Button("Choice 4") {
                    print("Choice 4")
                }
                .tint(.cyan)
                .buttonStyle(.borderedProminent)

                Button("Choice 5") {
                    print("Choice 5")
                }
                .tint(.purple)
                .buttonStyle(.borderedProminent)

                Button("Choice 6") {
                    print("Choice 6")
                }
                .tint(.brown)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    TTSView()
}
