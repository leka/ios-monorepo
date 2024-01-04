// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State var isConnectionViewPresented = true
    @State var isUpdateStatusViewPresented = false

    var body: some View {
        InformationView(
            isConnectionViewPresented: self.$isConnectionViewPresented,
            isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented
        )
        .fullScreenCover(isPresented: self.$isConnectionViewPresented) {
            ConnectionView()
        }
        .fullScreenCover(isPresented: self.$isUpdateStatusViewPresented) {
            UpdateStatusView(isConnectionViewPresented: self.$isConnectionViewPresented)
        }
    }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "en"))
        ContentView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}
