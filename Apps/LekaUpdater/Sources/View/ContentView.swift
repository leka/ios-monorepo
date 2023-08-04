// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @State var isConnectionViewPresented = true

    var body: some View {
        InformationView(isConnectionViewPresented: $isConnectionViewPresented)
            .fullScreenCover(isPresented: $isConnectionViewPresented) {
                ConnectionView()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
