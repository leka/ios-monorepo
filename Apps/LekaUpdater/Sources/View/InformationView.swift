// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InformationView: View {
    @State private var robotNeedUpdate = false
    @EnvironmentObject var firmware: FirmwareManager

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
                    Text("Firmware v\(firmware.currentVersion) Change Log")
                        .font(.title3)
                        .bold()
                }

                Section {
                    if robotNeedUpdate {
                        RobotUpdateAvailableView()
                    } else {
                        Text("Votre robot est à jour ! Vous n'avez rien à faire 👌")
                            .font(.title2)
                            .bold()
                            .padding()
                    }
                } header: {
                    Text("Firmware Update")
                        .font(.title3)
                        .bold()
                }
            }

            // TODO: Remove this switch
            Button("Switch [DEBUG ONLY]") {
                robotNeedUpdate.toggle()
            }
            .padding()
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static let firmware = FirmwareManager()
    static var previews: some View {
        InformationView()
            .environmentObject(firmware)
    }
}
