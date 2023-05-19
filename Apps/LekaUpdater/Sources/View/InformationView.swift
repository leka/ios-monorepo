// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InformationView: View {
    @EnvironmentObject var firmware: FirmwareManager
    @EnvironmentObject var robot: DummyRobotModel

    var body: some View {
        VStack {
            LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 120)

            Form {
                Section {
                    RobotInformationView()
                } header: {
                    Text("Information du robot")
                        .font(.title3)
                        .bold()
                }

                Section {
                    ChangelogView()
                } header: {
                    Text("Contenu de la dernière mise à jour")
                        .font(.title3)
                        .bold()
                }

                Section {
                    if firmware.compareWith(version: robot.osVersion) == .needsUpdate {
                        RobotUpdateAvailableView(robot: robot)
                    } else {
                        Text("Votre robot est à jour ! Vous n'avez rien à faire 👌")
                            .font(.title2)
                            .bold()
                            .padding()
                    }
                } header: {
                    Text("Démarches à effectuer")
                        .font(.title3)
                        .bold()
                }
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static let firmware = FirmwareManager()
    static let robot = DummyRobotModel()
    static var previews: some View {
        InformationView()
            .environmentObject(firmware)
            .environmentObject(robot)
    }
}
