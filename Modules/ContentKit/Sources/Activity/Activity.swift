// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

// MARK: - Activity

public struct Activity: Codable, Identifiable {
    // MARK: Public

    public var id: String { self.uuid }

    // MARK: Internal

    let uuid: String
    let name: String
    let authors: [String] // TODO: (@ladislas) - implement authors
    let skills: [String] // TODO: (@ladislas) - implement skills
    let tags: [String] // TODO: (@ladislas) - implement tags
    let locales: [String] // TODO: (@ladislas) - implement locale
    let l10n: [Localization]
    let gameengine: GameEngine
    let exercises: [ExerciseGroup]
}

// MARK: Activity.Localization

extension Activity {
    struct Localization: Codable {
        let locale: String // TODO: (@ladislas) - implement locale
        let details: Details
    }
}

// MARK: Activity.Details

extension Activity {
    struct Details: Codable {
        let icon: String
        let title: String
        let subtitle: String
        let description: String
        let instructions: String
    }
}

// MARK: - GameEngine

struct GameEngine: Codable {
    // MARK: Internal

    let shuffleExercises: Bool
    let shuffleSequences: Bool

    // MARK: Private

    private enum CodingKeys: String, CodingKey {
        case shuffleExercises = "shuffle_exercises"
        case shuffleSequences = "shuffle_sequences"
    }
}

// MARK: - ExerciseGroup

struct ExerciseGroup: Codable {
    let group: [Exercise]
}
