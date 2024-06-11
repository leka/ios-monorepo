// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public extension ExerciseCompletionData {
    struct StandardExercisePayload: Codable {
        // MARK: Lifecycle

        public init(numberOfTrials: Int, numberOfAllowedTrials: Int) {
            self.numberOfTrials = numberOfTrials
            self.numberOfAllowedTrials = numberOfAllowedTrials
        }

        // MARK: Public

        public var numberOfTrials: Int
        public var numberOfAllowedTrials: Int
    }

    struct SuperSimonExercisePayload: Codable {
        // MARK: Lifecycle

        public init(numberOfTrials: Int, numberOfAllowedTrials: Int) {
            self.numberOfTrials = numberOfTrials
            self.numberOfAllowedTrials = numberOfAllowedTrials
        }

        // MARK: Public

        public var numberOfTrials: Int
        public var numberOfAllowedTrials: Int
    }

    struct DanceFreezePayload: Codable {
        // MARK: Lifecycle

        public init(chosenSong: String) {
            self.chosenSong = chosenSong
        }

        // MARK: Public

        public var chosenSong: String
    }
}
