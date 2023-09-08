// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Inspired from RobotKit

import DesignKit
import SwiftUI

struct RobotConnectionView: View {

    @StateObject var robotConnectionViewModel: RobotConnectionViewModel = RobotConnectionViewModel()

    private let bold15: Font = .system(size: 15, weight: .bold)

    var body: some View {
        VStack(spacing: 60) {
            Spacer()

            RobotGridView()
                .environmentObject(robotConnectionViewModel)

            HStack(spacing: 40) {
                Spacer()
                scanButton
                connectDisconnectButton
                Spacer()
            }
            .padding(.vertical, 20)
        }
    }

    private var scanButton: some View {
        Button(
            action: {
                robotConnectionViewModel.scanForRobots()
            },
            label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Rechercher")
                }
                .font(bold15)
                .foregroundColor(.white)
                .padding(6)
                .frame(width: 210)

            }
        )
        .onAppear(perform: robotConnectionViewModel.onAppear)
        .buttonStyle(.borderedProminent)
        .tint(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
    }

    private var connectDisconnectButton: some View {
        Button(
            action: {
                if robotConnectionViewModel.disconnected {
                    robotConnectionViewModel.connectToSelectedRobot()
                } else {
                    robotConnectionViewModel.disconnectFromRobot()
                }
            },
            label: {
                HStack {
                    Image(systemName: "checkmark.circle")
                    if robotConnectionViewModel.disconnected {
                        Text("Se connecter")

                    } else {
                        Text("Se déconnecter")
                    }
                }
                .font(bold15)
                .foregroundColor(.white)
                .padding(6)
                .frame(width: 210)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(robotConnectionViewModel.connected ? DesignKitAsset.Colors.lekaOrange.swiftUIColor : .accentColor)
        .disabled(robotConnectionViewModel.connectionButtonDisabled)
    }
}

struct RobotListView_Previews: PreviewProvider {
    static var previews: some View {
        RobotConnectionView()
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
