// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @StateObject var robot = RobotPeripheralViewModel()

    var body: some View {
        //        InformationView()
        Text("hello")
            .fullScreenCover(isPresented: $robot.isDisconnected) {
                NavigationStack {
                    ConnectionView()
                        .environmentObject(robot)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
