// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @State var isConnectionViewPresented = true
    @State var isUpdateStatusViewPresented = false

    var body: some View {
        InformationView(
            isConnectionViewPresented: $isConnectionViewPresented,
            isUpdateStatusViewPresented: $isUpdateStatusViewPresented
        )
        .fullScreenCover(isPresented: $isConnectionViewPresented) {
            ConnectionView()
        }
        .fullScreenCover(isPresented: $isUpdateStatusViewPresented) {
            UpdateStatusView(isConnectionViewPresented: $isConnectionViewPresented)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))
        ContentView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}
