// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct AudioRecording: Codable, Hashable, Equatable {
    // MARK: Lifecycle

    public init(name: String, file: String) {
        self.name = name
        self.file = file
    }

    public init(_ song: Song) {
        self.name = song.details.name
        self.file = song.details.file
    }

    // MARK: Public

    public enum Song: String, Codable {
        case earlyBird
        case emptyPage
        case gigglySquirrel
        case handsOn
        case happyDays
        case inTheGame
        case littleByLittle

        // MARK: Internal

        var details: (name: String, file: String) {
            switch self {
                case .earlyBird:
                    (name: "Early Bird", file: "Early_Bird")
                case .emptyPage:
                    (name: "Empty Page", file: "Empty_Page")
                case .gigglySquirrel:
                    (name: "Giggly Squirrel", file: "Giggly_Squirrel")
                case .handsOn:
                    (name: "Hands on", file: "Hands_On")
                case .happyDays:
                    (name: "Happy Days", file: "Happy_Days")
                case .inTheGame:
                    (name: "In the game", file: "In_The_Game")
                case .littleByLittle:
                    (name: "Little by Little", file: "Little_by_little")
            }
        }
    }

    public let name: String
    public let file: String
}
