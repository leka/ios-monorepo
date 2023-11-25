// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HomeView: View {

    @ObservedObject var navigation: Navigation = Navigation.shared

    var body: some View {
        VStack {
            Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
                .font(.largeTitle)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.cyan)
        .navigationTitle("What's new?")
    }
}

#Preview {
    HomeView()
}
