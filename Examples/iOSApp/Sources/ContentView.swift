// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SFSymbolsMacro
import SwiftUI

// MARK: - Symbols

@SFSymbol
enum Symbols: String {
    case circle
    case circleFill = "circle.fill"
    case shareIcon = "square.and.arrow.up"
    case globe
}

// MARK: - ContentView

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.teal
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(systemName: Symbols.globe())
                    .font(.largeTitle)
                    .foregroundStyle(.white)

                Text("Hello, Macros!")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
        }
    }
}

// MARK: - ContentView_Previews

#Preview {
    ContentView()
}
