// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI
import Version

// MARK: - InformationView

struct InformationView: View {
    // MARK: Internal

    @StateObject var viewModel = InformationViewModel()
    @Binding var isConnectionViewPresented: Bool
    @Binding var isUpdateStatusViewPresented: Bool

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    if self.viewModel.showRobotCannotBeUpdated {
                        RobotCannotBeUpdatedIllustration(size: 200)

                        Text(self.viewModel.robotName)
                            .font(.title3)

                        Text(
                            l10n.information.status.robotCannotBeUpdatedText.characters
                                + " - (LekaOS v\(self.viewModel.robotOSVersion))"
                        )
                        .font(.title2)
                        .multilineTextAlignment(.center)

                    } else if self.viewModel.showRobotNeedsUpdate {
                        RobotNeedsUpdateIllustration(size: 200)

                        Text(self.viewModel.robotName)
                            .font(.title3)

                        Text(l10n.information.status.robotUpdateAvailable)
                            .font(.title2)
                    } else {
                        RobotUpToDateIllustration(size: 200)

                        Text(self.viewModel.robotName)
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
                            .stroke(.lkStroke, lineWidth: 3)
                    )
                    .padding([.horizontal], 3)
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
                        .stroke(.lkStroke, lineWidth: 3)
                )
                .padding([.horizontal], 3)
                .padding([.vertical], 10)

                if self.viewModel.showRobotNeedsUpdate {
                    RobotUpdateAvailableView(isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented)
                        .padding([.vertical], 10)
                }

                LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .padding(35)
            }
            .padding([.horizontal], 20)
        }
        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
        .background(.lkBackground)
        .onChange(of: self.isViewVisible) {
            if self.isViewVisible { self.viewModel.onViewReappear() }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(l10n.main.appName)
                        .font(.title2)
                        .bold()
                    Text(l10n.main.appDescription)
                }
                .foregroundColor(.lkNavigationTitle)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.isConnectionViewPresented = true
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text(l10n.toolbar.connectionButton)
                    }
                }
            }
        }
    }

    // MARK: Private

    private var isViewVisible: Bool {
        !self.isConnectionViewPresented && !self.isUpdateStatusViewPresented
    }
}

#Preview {
    NavigationStack {
        InformationView(
            isConnectionViewPresented: .constant(false),
            isUpdateStatusViewPresented: .constant(false)
        )
        .onAppear {
            Robot.shared.name.send("Leka")
            Robot.shared.battery.send(75)
            Robot.shared.isCharging.send(true)
            Robot.shared.osVersion.send(Version(1, 3, 0))
        }
    }
}
