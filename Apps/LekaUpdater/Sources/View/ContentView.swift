// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @StateObject var robot = RobotPeripheralViewModel()
    @State var isPresented = true

    var body: some View {
        Text("LekaUpdater")
            .fullScreenCover(isPresented: $isPresented) {
                NavigationStack {
                    ConnectionView()
                }  // TODO: Remove NavigationStack and set Title and Continue button correctly
            }
            .environmentObject(robot)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var firmware = FirmwareManager()

    static var previews: some View {
        ContentView()
            .environmentObject(firmware)
    }
}
