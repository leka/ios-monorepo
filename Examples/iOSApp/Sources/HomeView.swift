// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {

    init() {
        print("init HomeView")
    }

    var body: some View {
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blue)
    }
}

#Preview {
    HomeView()
}
