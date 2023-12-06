// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct RobotListView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot
    @EnvironmentObject var botVM: BotViewModel

    var body: some View {
        VStack {
            Spacer()

            BotStore(botVM: botVM)

            HStack(spacing: 60) {
                Spacer()

                searchButton
                connectionButton

                Spacer()
            }
            .padding(.vertical, 20)

            Spacer()
        }
    }

    private var searchButton: some View {
        Button(
            action: {
                if !bleManager.isScanning {
                    bleManager.searchForPeripherals()
                } else {
                    bleManager.stopSearching()
                }
            },
            label: {
                Group {
                    if !bleManager.isScanning {
                        Text("Search for peripheral")
                            .font(.body)
                            .padding(6)
                            .frame(width: 210)
                    } else {
                        Text("Stop searching")
                            .font(.body)
                            .padding(6)
                            .frame(width: 210)
                    }
                }
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(Color(.blue))
    }

    private var connectionButton: some View {
        Button(
            action: {
                if botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex {
                    bleManager.disconnect()

                    botVM.currentlyConnectedBotIndex = nil
                    botVM.currentlyConnectedBotName = ""
                    botVM.botIsConnected = false
                } else {
                    bleManager.connect(bleManager.peripherals[botVM.currentlySelectedBotIndex!])
                        .receive(on: DispatchQueue.main)
                        .sink(
                            receiveCompletion: { _ in
                                // nothing to do
                            },
                            receiveValue: { peripheral in
                                let connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
                                robot.robotPeripheral = connectedRobotPeripheral
                            }
                        )
                        .store(in: &bleManager.cancellables)
                    botVM.currentlyConnectedBotIndex = botVM.currentlySelectedBotIndex
                    botVM.botIsConnected = true
                }
            },
            label: {
                Group {
                    if botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex {
                        Text("Se déconnecter")
                    } else {
                        Text("Se connecter")
                    }
                }
                .padding(6)
                .frame(width: 210)
            }
        )
        .buttonStyle(.borderedProminent)
        .tint(botVM.currentlyConnectedBotIndex == botVM.currentlySelectedBotIndex ? Color(.orange) : .accentColor)
        .disabled(bleManager.peripherals.isEmpty)
        .disabled(botVM.currentlySelectedBotIndex == nil)
    }
}
