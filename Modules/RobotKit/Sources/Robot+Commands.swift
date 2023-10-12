// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Robot {

    static let kHeaderPattern: [UInt8] = [0x2A, 0x2A, 0x2A, 0x2A]

    func commandGenerator(commands: [UInt8]...) -> Data {
        commandGenerator(commands: commands)
    }

    func commandGenerator(commands: [[UInt8]]) -> Data {
        let commands = commands.filter { $0 != [] }
        var output: [UInt8] = []

        output.append(contentsOf: Robot.kHeaderPattern)
        output.append(UInt8(commands.count))

        for command in commands {
            output.append(contentsOf: command)
        }

        return Data(output)
    }

}
