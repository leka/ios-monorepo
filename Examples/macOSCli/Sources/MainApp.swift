// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ArgumentParser

@main
struct Greetings: ParsableCommand {
    @Flag(help: "Include a counter with each repetition.")
    var includeCounter = false

    @Option(name: .shortAndLong, help: "The number of times to great 'name'.")
    var count: Int?

    @Argument(help: "The phrase to repeat.")
    var name: String = "macOS Cli Example!"

    mutating func run() throws {
        let repeatCount = count ?? 2

        for i in 1...repeatCount {
            if includeCounter {
                print("\(i): Hello, \(name)")
            } else {
                print("Hello, \(name)")
            }
        }
    }
}
