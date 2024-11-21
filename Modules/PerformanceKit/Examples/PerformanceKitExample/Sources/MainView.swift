// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MainView: View {
    @State var count = 1

    var body: some View {
        Text("Hello, PerformanceKit!")
            .font(.largeTitle)
    }
}

#Preview {
    MainView()
}
