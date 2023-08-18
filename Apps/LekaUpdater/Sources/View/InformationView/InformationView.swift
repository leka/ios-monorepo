// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct InformationView: View {
    @StateObject var viewModel = InformationViewModel()
    @Binding var isConnectionViewPresented: Bool
    @Binding var isUpdateStatusViewPresented: Bool

    private var isViewVisible: Bool {
        !self.isConnectionViewPresented && !self.isUpdateStatusViewPresented
    }

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Group {
                            if viewModel.showRobotNeedsUpdate {
                                RobotNeedsUpdateIllustration(size: 200)

                                Text(viewModel.robotName)
                                    .font(.title3)

                                Text("⬆️ An update is available 📦")
                                    .font(.title2)
                            } else {
                                RobotUpToDateIllustration(size: 200)

                                Text(viewModel.robotName)
                                    .font(.title3)

                                Text("🤖 Your robot is up to date ! 🎉 You don't have to do anything 👌")
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
                        Text("Robot information")
                            .textCase(nil)
                            .font(.title)
                    }

                    Section {
                        DisclosureGroup {
                            ChangelogView()
                                .padding()
                        } label: {
                            Text("List of changes made")
                                .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                        }
                        .accentColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    } header: {
                        Text("Information about LekaOS v\(viewModel.firmwareVersion)")
                            .textCase(nil)
                            .font(.title)
                    }

                    if viewModel.showRobotNeedsUpdate {
                        Section {
                            RobotUpdateAvailableView(isUpdateStatusViewPresented: $isUpdateStatusViewPresented)
                        } header: {
                            Text("Robot update status")
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

                            // TODO(@YannL): Remove DEBUG
                            Button("Switch (debug)", action: viewModel.switchRobotVersionForDebug)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .onChange(of: isViewVisible) { isVisible in
                if isVisible { viewModel.onViewReappear() }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Leka Updater")
                            .font(.title2)
                            .bold()
                        Text("The app to update your Leka robots!")
                    }
                    .foregroundColor(.accentColor)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isConnectionViewPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Connection")
                        }
                    }
                }
            }
        }
    }
}

struct InformationView_Previews: PreviewProvider {
    @State static var isConnectionViewPresented = false
    @State static var isUpdateStatusViewPresented = false

    static var previews: some View {
        InformationView(
            isConnectionViewPresented: $isConnectionViewPresented,
            isUpdateStatusViewPresented: $isUpdateStatusViewPresented
        )
        .onAppear {
            globalRobotManager.name = "Leka"
            globalRobotManager.battery = 75
            globalRobotManager.isCharging = true
            globalRobotManager.osVersion = "1.3.0"
        }
    }
}
