// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotConnectionView: View {
    var body: some View {
        VStack(spacing: 60) {
            VStack(spacing: 20) {
                ForEach((1...5), id: \.self) {
                    Text("Robot \($0)")
                }
            }

            HStack(spacing: 40) {
                Button(
                    action: {
                        print("scanning...")
                    },
                    label: {
                        Text("Search for robots")
                    })

                Button(
                    action: {
                        print("connecting...")
                    },
                    label: {
                        Text("Connect to robot")
                    })
            }
        }
    }
}

struct RobotListView_Previews: PreviewProvider {
    static var previews: some View {
        RobotConnectionView()
    }
}
