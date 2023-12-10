// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

struct MainView: View {
    // MARK: Internal

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ConnectedRobotInformationView()

                Button {
                    self.presentRobotConnection.toggle()
                } label: {
                    Text("Connect robot")
                }
                .fullScreenCover(isPresented: self.$presentRobotConnection) {
                    RobotConnectionView(viewModel: RobotConnectionViewModel())
                }

                NavigationLink(
                    destination: {
                        RobotControlView(viewModel: RobotControlViewModel(robot: Robot.shared))
                    },
                    label: {
                        Text("Go to robot control")
                    }
                )
            }
            .navigationTitle("RobotKit Explorer")
        }
    }

    // MARK: Private

    @State private var presentRobotConnection: Bool = false
}

#Preview {
    MainView()
}
