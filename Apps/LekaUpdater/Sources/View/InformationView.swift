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
                    Text("Informations du robot")
                        .textCase(nil)
                        .font(.title)
                }

                Section {
                    DisclosureGroup {
                        ChangelogView()
                            .padding()
                    } label: {
                        Text("Liste des changements apportés")
                    }
                } header: {
                    Text("Informations sur LekaOS v\(robot.osVersion)")
                        .textCase(nil)
                        .font(.title)
                }

                Section {
                    if firmware.compareWith(version: robot.osVersion) == .needsUpdate {
                        RobotUpdateAvailableView(robot: robot)
                    } else {
                        Text("🤖 Votre robot est à jour ! 🎉 Vous n'avez rien à faire 👌")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                    }
                } header: {
                    Text("État de mise à jour du robot")
                        .textCase(nil)
                        .font(.title)
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
