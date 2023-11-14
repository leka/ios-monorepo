// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI
import Version

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
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        if viewModel.showRobotCannotBeUpdated {
                            RobotCannotBeUpdatedIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text(
                                l10n.information.status.robotCannotBeUpdatedText.characters
                                    + " - (LekaOS v\(viewModel.robotOSVersion))"
                            )
                            .font(.title2)
                            .multilineTextAlignment(.center)

                        } else if viewModel.showRobotNeedsUpdate {
                            RobotNeedsUpdateIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text(l10n.information.status.robotUpdateAvailable)
                                .font(.title2)
                        } else {
                            RobotUpToDateIllustration(size: 200)

                            Text(viewModel.robotName)
                                .font(.title3)

                            Text(l10n.information.status.robotIsUpToDate)
                                .font(.title2)
                        }
                    }
                    .padding([.bottom], 10)

                    RobotInformationView()
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(DesignKitAsset.Colors.lightGray.swiftUIColor, lineWidth: 3)
                        )
                        .padding([.vertical], 10)

                    DisclosureGroup {
                        ChangelogView()
                            .padding()
                    } label: {
                        Text(l10n.information.changelogSectionTitle)
                            .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    }
                    .accentColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(DesignKitAsset.Colors.lightGray.swiftUIColor, lineWidth: 3)
                    )
                    .padding([.vertical], 10)

                    if viewModel.showRobotNeedsUpdate {
                        RobotUpdateAvailableView(isUpdateStatusViewPresented: $isUpdateStatusViewPresented)
                            .padding([.vertical], 10)
                    }

                    VStack {
                        LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                            .padding(35)
                    }
                }
                .padding([.horizontal], 20)
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .onChange(of: isViewVisible) { isVisible in
                if isVisible { viewModel.onViewReappear() }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(l10n.main.appName)
                            .font(.title2)
                            .bold()
                        Text(l10n.main.appDescription)
                    }
                    .foregroundColor(.accentColor)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isConnectionViewPresented = true
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text(l10n.toolbar.connectionButton)
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
            globalRobotManager.osVersion = Version(1, 3, 0)
        }
        .environment(\.locale, .init(identifier: "en"))

        InformationView(
            isConnectionViewPresented: $isConnectionViewPresented,
            isUpdateStatusViewPresented: $isUpdateStatusViewPresented
        )
        .onAppear {
            globalRobotManager.name = "Leka"
            globalRobotManager.battery = 75
            globalRobotManager.isCharging = true
            globalRobotManager.osVersion = Version(1, 3, 0)
        }
        .environment(\.locale, .init(identifier: "fr"))
    }
}
