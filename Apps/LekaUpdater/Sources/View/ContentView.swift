// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @State var isPresented = true

    var body: some View {
        InformationView()
            .fullScreenCover(isPresented: $isPresented) {
                NavigationStack {
                    ConnectionView()
                }  // TODO: Remove NavigationStack and set Title and Continue button correctly
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
