// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject var connectedRobot: RobotPeripheralViewModel
    @EnvironmentObject var firmware: FirmwareManager

    @StateObject private var viewModel = ConnectionViewModel()

    var body: some View {
        VStack {
            RobotConnectionView(robotConnectionViewModel: viewModel.robotConnectionViewModel)

            LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .padding(35)
        }
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Leka Updater")
                        .font(.title2)
                        .bold()
                    Text("L'application pour mettre à jour vos robots Leka !")
                }
                .foregroundColor(.accentColor)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
//                    InformationView()
//                        .environmentObject(firmware)
//                        .environmentObject(viewModel.connectedRobot)
                    connectedRobot = viewModel.connectedRobot
                    connectedRobot.isDisconnected = false
                } label: {
                    HStack {
                        Text("Continuer")
                        Image(systemName: "chevron.forward")
                    }
                }
                .disabled(viewModel.continueButtonDisabled)
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var firmware = FirmwareManager()

    static var previews: some View {
        NavigationStack {
            ConnectionView()
                .environmentObject(firmware)
        }
    }
}
