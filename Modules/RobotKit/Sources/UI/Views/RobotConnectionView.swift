// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import DesignKit
import SwiftUI

public struct RobotConnectionView: View {
    // MARK: Lifecycle

    public init(viewModel: RobotConnectionViewModel = RobotConnectionViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                switch self.viewModel.robotDiscoveries.count {
                    case 0:
                        Spacer()
                        self.searchingView
                        Spacer()
                    default:
                        self.robotDiscoveryGridView
                }

                Divider()
                    .padding(.horizontal)
                    .padding(.horizontal)

                HStack {
                    if !self.viewModel.connected {
                        self.connectButton
                    } else {
                        self.disconnectButton
                    }
                    self.continueButton
                }
                .padding(.top, 15)
                .padding(.bottom, 40)
            }
            .background(BackgroundView())
            .onAppear {
                self.viewModel.scanForRobots()
            }
            .onDisappear {
                self.viewModel.stopScanning()
            }
            .navigationTitle("Choose a robot")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
        }
    }

    // MARK: Internal

    struct BackgroundView: View {
        var body: some View {
            DesignKitAsset.Images.interfaceCloud.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
        }
    }

    @StateObject var viewModel: RobotConnectionViewModel

    @Environment(\.dismiss) var dismiss

    // MARK: Private

    private let columns: [GridItem] = [
        GridItem(),
        GridItem(),
        GridItem(),
    ]

    private var searchingView: some View {
        // TODO(@ladislas): review "no robot found" interface
        // TODO(@ladislas): handle no robots found after xx seconds + add refresh button
        VStack {
            Text("Searching for robots...")
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

    private var searchButton: some View {
        ButtonBordered(tint: .blue) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Rechercher")
            }
            .frame(minWidth: 200)
        } action: {
            // TODO(@ladislas): implement in the future
        }
    }

    private var connectButton: some View {
        ButtonBordered(tint: .green) {
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Se connecter")
            }
            .frame(minWidth: 200)
        } action: {
            withAnimation {
                self.viewModel.connectToRobot()
            }
        }
        .disabled(self.viewModel.selectedDiscovery == nil)
    }

    private var disconnectButton: some View {
        ButtonBordered(tint: .orange) {
            HStack {
                Image(systemName: "xmark.circle")
                Text("Se déconnecter")
            }
            .frame(minWidth: 200)
        } action: {
            let animation = Animation.easeOut(duration: 0.5)
            withAnimation(animation) {
                self.viewModel.disconnectFromRobot()
            }
        }
    }

    @ViewBuilder
    private var continueButton: some View {
        if self.viewModel.connected {
            ButtonFilled(tint: .green) {
                HStack {
                    Image(systemName: "arrow.right.circle")
                    Text("Continuer")
                }
                .frame(minWidth: 200)
            } action: {
                self.dismiss()
            }
            .disabled(false)
        } else {
            ButtonBordered(tint: .gray) {
                HStack {
                    Image(systemName: "arrow.right.circle")
                    Text("Continuer")
                }
                .frame(minWidth: 200)
            } action: {
                // nothing to do
            }
            .disabled(true)
        }
    }

    @ViewBuilder
    private func robotDiscoveryCellView(for discovery: RobotDiscoveryModel) -> some View {
        if discovery == self.viewModel.connectedDiscovery {
            RobotDiscoveryView(
                discovery: RobotDiscoveryViewModel(
                    discovery: discovery, status: .connected
                )
            )
        } else if discovery == self.viewModel.selectedDiscovery {
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
    return RobotConnectionView(viewModel: viewModel)
}
