// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct HelloView: View {
    var color: Color
    var name: String

    public init(color: Color, name: String) {
        self.color = color
        self.name = name
    }

    public var body: some View {
        ZStack {
            color
                .ignoresSafeArea()

            Text("Hello, \(name)!")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView(color: .blue, name: "Dynamic Library Module Example")
    }
}
