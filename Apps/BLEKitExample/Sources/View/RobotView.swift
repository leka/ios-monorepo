// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import SwiftUI

// MARK: - ReadOnlyView

struct ReadOnlyView: View {
    var characteristicName: String
    var characteristicValue: String

    var body: some View {
        HStack {
            Text("\(self.characteristicName): ")
                .bold()
            Text(self.characteristicValue)
        }
    }
}

// MARK: - RobotView

struct RobotView: View {
    @EnvironmentObject var bleManager: BLEManager
    @EnvironmentObject var robot: Robot

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                ReadOnlyView(characteristicName: "Manufacturer", characteristicValue: self.robot.manufacturer)
                ReadOnlyView(characteristicName: "Model Number", characteristicValue: self.robot.modelNumber)
                ReadOnlyView(characteristicName: "Serial Number", characteristicValue: self.robot.serialNumber)
                ReadOnlyView(characteristicName: "OS Version", characteristicValue: self.robot.osVersion)
            }

            Group {
                ReadOnlyView(characteristicName: "Battery", characteristicValue: "\(self.robot.battery)")
                ReadOnlyView(
                    characteristicName: "Charging status", characteristicValue: self.robot.isCharging ? "On" : "Off"
                )
            }

            Group {
                ReadOnlyView(characteristicName: "Magic Card (ID)", characteristicValue: "\(self.robot.magicCardID)")
                ReadOnlyView(
                    characteristicName: "MagicCard (Language)", characteristicValue: self.robot.magicCardLanguage
                )
            }

            Group {
                HStack {
                    Button {
                        self.robot.runReinforcer(self.robot.commands.command.Motivator.blinkGreen)
                    } label: {
                        Image("reinforcer-1-green-spin")
                    }
                    Button {
                        self.robot.runReinforcer(self.robot.commands.command.Motivator.spinBlink)
                    } label: {
                        Image("reinforcer-2-violet_green_blink-spin")
                    }
                    Button {
                        self.robot.runReinforcer(self.robot.commands.command.Motivator.fire)
                    } label: {
                        Image("reinforcer-3-fire-static")
                    }
                    Button {
                        self.robot.runReinforcer(self.robot.commands.command.Motivator.sprinkles)
                    } label: {
                        Image("reinforcer-4-glitters-static")
                    }
                    Button {
                        self.robot.runReinforcer(self.robot.commands.command.Motivator.rainbow)
                    } label: {
                        Image("reinforcer-5-rainbow-static")
                    }
                }
            }
        }
        .padding()
        .toolbar {
            Button {
                self.bleManager.disconnect()
            } label: {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
        }
    }
}
