// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @State var connectedRobot: RobotPeripheralViewModel?
    @State var isRobotNotConnected = true

    var body: some View {
        //        InformationView()
        Text("hello")
            .fullScreenCover(isPresented: $isRobotNotConnected) {
                NavigationStack {
                    ConnectionView()
                        .onChange(of: connectedRobot) { connectedRobot in
                            self.isRobotNotConnected = connectedRobot == nil
                        }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
