// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - HelloView

public struct HelloView: View {
    // MARK: Lifecycle

    public init(color: Color, name: String) {
        self.color = color
        self.name = name
    }

    // MARK: Public

    public var body: some View {
        ZStack {
            self.color
                .ignoresSafeArea()

            Text("Hello, \(self.name)!")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: Internal

    var color: Color
    var name: String
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView(color: .blue, name: "Dynamic Library Module Example")
    }
}
