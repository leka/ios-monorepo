// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {
    @State var connectedRobot: RobotPeripheralViewModel?
    @Binding var isRobotConnected: Bool {
        connectedRobot != nil
    }
    
    var body: some View {
        InformationView()
            .fullScreenCover(isPresented: $isRobotConnected) {
                ConnectionView()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
