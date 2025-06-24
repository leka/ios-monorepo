// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State var isConnectionViewPresented = false
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
                RobotConnectionView()
            }
            .onAppear {
                globalFirmwareManager.currentVersion = Robot.kLatestFirmwareVersion
            }
        }
        .fullScreenCover(isPresented: self.$isUpdateStatusViewPresented) {
            NavigationStack {
                UpdateStatusView(isConnectionViewPresented: self.$isConnectionViewPresented, isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented)
            }
        }
    }
}

#Preview {
    ContentView()
}
