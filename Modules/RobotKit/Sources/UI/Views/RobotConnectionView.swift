// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import DesignKit
import LocalizationKit
import SwiftUI

public struct RobotConnectionView: View {
    // MARK: Lifecycle

    public init(viewModel: RobotConnectionViewModel = RobotConnectionViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        VStack(spacing: 10) {
            if self.viewModel.connectingToRestartingRobot {
                ProgressView()
                Text(l10n.RobotKit.RobotConnectionView.restartingDeepSleepRobotText)
            } else if self.robotViewModel.isConnected {
                ConnectedRobotView(robot: self.robotViewModel.robot)
            } else {
                switch self.viewModel.managerState {
                    case .poweredOn:
                        switch self.viewModel.robotDiscoveries.count {
                            case 0:
                                Spacer()
                                self.searchingView
                                Spacer()
                            default:
                                self.robotDiscoveryGridView
                        }
                    case .poweredOff:
                        BluetoothOffView()
                    case .unauthorized:
                        BluetoothUnauthorizedView()
                    case .unknown:
                        Spacer()
                        self.searchingView
                        Spacer()

                    default:
                        Spacer()
                        Text("DEBUG - shoud not see this")
                        Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.lkBackground)
        .onAppear {
            self.viewModel.scanForRobots()
        }
        .onDisappear {
            self.viewModel.stopScanning()
        }
        .onChange(of: self.scenePhase) { newPhase in
            if newPhase == .active {
                self.viewModel.tryToConnectToRobotConnectedInAnotherApp()
            }
        }
        .navigationTitle(String(l10n.RobotKit.RobotConnectionView.navigationTitle.characters))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.dismiss()
                } label: {
                    Text(l10n.RobotKit.RobotConnectionView.closeButton)
                }
            }
            if !self.viewModel.connectingToRestartingRobot {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.connectToRobot()
                    } label: {
                        Text(l10n.RobotKit.RobotConnectionView.connectButton)
                    }
                    .disabled(self.viewModel.selectedDiscovery == nil)
                    .opacity(self.robotViewModel.isConnected ? 0 : 1)
                }
            }
        }
        .interactiveDismissDisabled(self.viewModel.connectingToRestartingRobot)
    }

    // MARK: Internal

    @Environment(\.scenePhase) var scenePhase

    @State var viewModel: RobotConnectionViewModel
    @Environment(\.dismiss) var dismiss

    // MARK: Private

    @Bindable private var robotViewModel: ConnectedRobotInformationViewModel = .init(robot: .shared)

    private let columns: [GridItem] = [
        GridItem(),
        GridItem(),
        GridItem(),
    ]

    private var searchingView: some View {
        // TODO(@ladislas): review "no robot found" interface
        // TODO(@ladislas): handle no robots found after xx seconds + add refresh button
        VStack {
            Text(l10n.RobotKit.RobotConnectionView.searchingViewText)
            ProgressView()
        }
    }

    private var robotDiscoveryGridView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: self.columns, spacing: 40) {
                ForEach(self.viewModel.robotDiscoveries) { discovery in
                    self.robotDiscoveryCellView(for: discovery)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                self.viewModel.select(discovery: discovery)
                            }
                        }
                }
            }
        }
    }

    @ViewBuilder
    private func robotDiscoveryCellView(for discovery: RobotDiscoveryModel) -> some View {
        if discovery == self.viewModel.selectedDiscovery {
            RobotDiscoveryView(
                discovery: RobotDiscoveryViewModel(
                    discovery: discovery, status: .selected
                )
            )
        } else {
            RobotDiscoveryView(
                discovery: RobotDiscoveryViewModel(
                    discovery: discovery, status: .unselected
                )
            )
        }
    }
}

#Preview {
    let viewModel: RobotConnectionViewModel = .mock()
    return Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                RobotConnectionView(viewModel: viewModel)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
}
