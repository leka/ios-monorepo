// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

struct RobotListView: View {
    // MARK: Internal

    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot
    @EnvironmentObject var botVM: BotViewModel

    var body: some View {
        VStack {
            Spacer()

            BotStore(botVM: self.botVM)

            HStack(spacing: 60) {
                Spacer()

                self.searchButton
                self.connectionButton

                Spacer()
            }
            .padding(.vertical, 20)

            Spacer()
        }
    }

    // MARK: Private

    private var searchButton: some View {
        Button(
            action: {
                if !self.bleManager.isScanning {
                    self.bleManager.searchForPeripherals()
                } else {
                    self.bleManager.stopSearching()
                }
            },
            label: {
                Group {
                    if !self.bleManager.isScanning {
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
                if self.botVM.currentlyConnectedBotIndex == self.botVM.currentlySelectedBotIndex {
                    self.bleManager.disconnect()

                    self.botVM.currentlyConnectedBotIndex = nil
                    self.botVM.currentlyConnectedBotName = ""
                    self.botVM.botIsConnected = false
                } else {
                    self.bleManager.connect(self.bleManager.peripherals[self.botVM.currentlySelectedBotIndex!])
                        .receive(on: DispatchQueue.main)
                        .sink(
                            receiveCompletion: { _ in
                                // nothing to do
                            },
                            receiveValue: { peripheral in
                                let connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
                                self.robot.robotPeripheral = connectedRobotPeripheral
                            }
                        )
                        .store(in: &self.bleManager.cancellables)
                    self.botVM.currentlyConnectedBotIndex = self.botVM.currentlySelectedBotIndex
                    self.botVM.botIsConnected = true
                }
            },
            label: {
                Group {
                    if self.botVM.currentlyConnectedBotIndex == self.botVM.currentlySelectedBotIndex {
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
        .tint(self.botVM.currentlyConnectedBotIndex == self.botVM.currentlySelectedBotIndex ? Color(.orange) : .accentColor)
        .disabled(self.bleManager.peripherals.isEmpty)
        .disabled(self.botVM.currentlySelectedBotIndex == nil)
    }
}
