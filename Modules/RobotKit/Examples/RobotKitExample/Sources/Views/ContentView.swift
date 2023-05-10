// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContentView: View {

    // MARK: - Environment variables

    // MARK: - Public functions

    // MARK: - Views

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                RobotConnectionView()

                NavigationLink(
                    destination: {
                        RobotControlView()
                            .navigationTitle("Robot Control")
                    },
                    label: {
                        Text("Go to robot control")
                    }
                )
                .contentShape(Rectangle())
            }
            .navigationTitle("Robot Connection")
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
