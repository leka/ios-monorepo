// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct InformationView: View {
    @StateObject var viewModel: InformationViewModel

    init(firmware: FirmwareManager) {
        self._viewModel = StateObject(
            wrappedValue: InformationViewModel(firmware: firmware))
    }

    var body: some View {
        VStack {
            Form {
                Section {
                    Group {
                        if viewModel.showRobotNeedsUpdate {
                            RobotNeedsUpdateIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text("⬆️ Une mise à jour est disponible 📦")
                                .font(.title2)
                        } else {
                            RobotUpToDateIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text("🤖 Votre robot est à jour ! 🎉 Vous n'avez rien à faire 👌")
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.clear)

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
                            .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    }
                    .accentColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                } header: {
                    Text("Informations sur LekaOS v\(viewModel.firmwareVersion)")
                        .textCase(nil)
                        .font(.title)
                }

                if viewModel.showRobotNeedsUpdate {
                    Section {
                        RobotUpdateAvailableView()
                    } header: {
                        Text("État de mise à jour du robot")
                            .textCase(nil)
                            .font(.title)
                    }
                }

                Section {
                    VStack {
                        LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .padding(35)

                        Button("Switch (debug)", action: viewModel.switchRobotVersionForDebug)  // TODO: Remove DEBUG
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
            }
        }
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        .onAppear(perform: viewModel.onAppear)
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
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    static let firmware = FirmwareManager()

    static var previews: some View {
        NavigationStack {
            InformationView(firmware: firmware)
        }
    }
}
