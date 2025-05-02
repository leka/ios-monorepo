// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State var isConnectionViewPresented = true
    @State var isUpdateStatusViewPresented = false

    var body: some View {
        NavigationStack {
            InformationView(
                isConnectionViewPresented: self.$isConnectionViewPresented,
                isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented
            )
        }
        .sheet(isPresented: self.$isConnectionViewPresented) {
            NavigationStack {
                ConnectionView()
            }
        }
        .fullScreenCover(isPresented: self.$isUpdateStatusViewPresented) {
            NavigationStack {
                UpdateStatusView(isConnectionViewPresented: self.$isConnectionViewPresented)
            }
        }
    }
}

#Preview {
    ContentView()
}
