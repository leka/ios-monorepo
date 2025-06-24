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

    @State var viewModel = InformationViewModel()
    @Binding var isConnectionViewPresented: Bool
    @Binding var isUpdateStatusViewPresented: Bool

    var body: some View {
        VStack {
            ScrollView {
                RobotStateView(viewModel: self.viewModel)

                if self.viewModel.showRobotNeedsUpdate, self.viewModel.isRobotConnected {
                    RobotUpdateAvailableView(isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented)
                        .padding(.vertical, 10)
                }

                if !self.viewModel.isRobotConnected {
                    SwitchRobotButton(isRobotConnected: false, isConnectionViewPresented: self.$isConnectionViewPresented)
                }

                if self.viewModel.isRobotConnected {
                    RobotInformationView()
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.lkStroke, lineWidth: 3)
                        )
                        .padding(.horizontal, 3)
                        .padding(.vertical, 10)
                }

                VStack(alignment: .leading, spacing: 0) {
                    Section {
                        DisclosureGroup {
                            ChangelogView()
                                .padding()
                        } label: {
                            Text(l10n.information.changelogDisclosureTitle)
                                .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                        }
                        .accentColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.lkStroke, lineWidth: 3)
                        )
                        .padding(.horizontal, 3)
                        .padding(.vertical, 10)
                    } header: {
                        Text(l10n.information.changelogSectionTitle)
                            .font(.headline)
                            .padding(.horizontal)
                    }
                }

                if self.viewModel.showRobotNeedsUpdate, self.viewModel.isRobotConnected {
                    SwitchRobotButton(isRobotConnected: true, isConnectionViewPresented: self.$isConnectionViewPresented)
                } else if self.viewModel.showRobotCanRollBack, self.viewModel.isRobotConnected {
                    RobotRollBackAvailableView(isUpdateStatusViewPresented: self.$isUpdateStatusViewPresented)
                        .padding(.vertical, 10)
                }

                LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .padding(35)
            }
            .padding(.horizontal, 20)
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
