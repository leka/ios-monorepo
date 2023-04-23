// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

struct ContentView: View {
    var body: some View {
        HelloView(color: .mint, name: "iOS App Example")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
