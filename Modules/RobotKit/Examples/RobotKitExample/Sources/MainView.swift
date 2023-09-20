// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MainView: View {

    @State private var presentRobotConnection: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ConnectedRobotInformationView()

                Button {
                    presentRobotConnection.toggle()
                } label: {
                    Text("Connect robot")
                }
                .fullScreenCover(isPresented: $presentRobotConnection) {
                    RobotConnectionView()
                }

                NavigationLink(
                    destination: {
                        RobotControlView()
                    },
                    label: {
                        Text("Go to robot control")
                    }
                )
            }
            .navigationTitle("RobotKit Explorer")
        }
    }

}

#Preview {
    MainView()
}
