// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - DanceFreeze

// swiftlint:disable nesting

public enum DanceFreeze {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let audioRecordingSongs: [AudioRecording.Song] = try container.decode(
                [AudioRecording.Song].self, forKey: .songs
            )
            self.songs = audioRecordingSongs.map { AudioRecording($0) }
            self.instructions = try container.decode(Instructions.self, forKey: .instructions)
        }

        // MARK: Public

        public let songs: [AudioRecording]
        public let instructions: Instructions

        public func encode(to _: Encoder) throws {
            fatalError("Not implemented")
        }

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case songs
            case instructions
        }
    }
}

// MARK: - DanceFreeze.Payload.Instructions

public extension DanceFreeze.Payload {
    struct Instructions: Codable {
        // MARK: Lifecycle

        public init(
            textMainInstructions: String, textMotionSelection: String, textMusicSelection: String, textButtonRotation: String,
            textButtonMovement: String, textButtonModeManual: String, textButtonModeAuto: String
        ) {
            self.textMainInstructions = textMainInstructions
            self.textMotionSelection = textMotionSelection
            self.textMusicSelection = textMusicSelection
            self.textButtonRotation = textButtonRotation
            self.textButtonMovement = textButtonMovement
            self.textButtonModeManual = textButtonModeManual
            self.textButtonModeAuto = textButtonModeAuto
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.textMainInstructions = try container.decode(String.self, forKey: .textMainInstructions)
            self.textMotionSelection = try container.decode(String.self, forKey: .textMotionSelection)
            self.textMusicSelection = try container.decode(String.self, forKey: .textMusicSelection)
            self.textButtonRotation = try container.decode(String.self, forKey: .textButtonRotation)
            self.textButtonMovement = try container.decode(String.self, forKey: .textButtonMovement)
            self.textButtonModeManual = try container.decode(String.self, forKey: .textButtonModeManual)
            self.textButtonModeAuto = try container.decode(String.self, forKey: .textButtonModeAuto)
        }

        // MARK: Public

        public let textMainInstructions: String
        public let textMotionSelection: String
        public let textMusicSelection: String
        public let textButtonRotation: String
        public let textButtonMovement: String
        public let textButtonModeManual: String
        public let textButtonModeAuto: String

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case textMainInstructions = "text_main_instructions"
            case textMotionSelection = "text_motion_selection"
            case textMusicSelection = "text_music_selection"
            case textButtonRotation = "text_button_rotation"
            case textButtonMovement = "text_button_movement"
            case textButtonModeManual = "text_button_mode_manual"
            case textButtonModeAuto = "text_button_mode_auto"
        }
    }
}

// swiftlint:enable nesting
