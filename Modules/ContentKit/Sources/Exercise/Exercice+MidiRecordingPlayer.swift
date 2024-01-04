// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting
public enum MidiRecordingPlayer {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.instructions = try container.decode(Instructions.self, forKey: .instructions)
            self.instrument = try container.decode(String.self, forKey: .instrument)

            let midiRecordingSongs = try container.decode([MidiRecording.Song].self, forKey: .songs)
            self.songs = midiRecordingSongs.map { MidiRecording($0) }
        }

        // MARK: Public

        public struct Instructions: Codable {
            // MARK: Lifecycle

            public init(
                textMusicSelection: String, textButtonPlay: String, textKeyboardPartial: String,
                textKeyboardFull: String
            ) {
                self.textMusicSelection = textMusicSelection
                self.textButtonPlay = textButtonPlay
                self.textKeyboardPartial = textKeyboardPartial
                self.textKeyboardFull = textKeyboardFull
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                self.textMusicSelection = try container.decode(String.self, forKey: .textMusicSelection)
                self.textButtonPlay = try container.decode(String.self, forKey: .textButtonPlay)
                self.textKeyboardPartial = try container.decode(String.self, forKey: .textKeyboardPartial)
                self.textKeyboardFull = try container.decode(String.self, forKey: .textKeyboardFull)
            }

            // MARK: Public

            public let textMusicSelection: String
            public let textButtonPlay: String
            public let textKeyboardPartial: String
            public let textKeyboardFull: String

            // MARK: Internal

            enum CodingKeys: String, CodingKey {
                case textMusicSelection = "text_music_selection"
                case textButtonPlay = "text_button_play"
                case textKeyboardPartial = "text_keyboard_partial"
                case textKeyboardFull = "text_keyboard_full"
            }
        }

        public let instructions: Instructions
        public let instrument: String
        public let songs: [MidiRecording]

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case instructions
            case instrument
            case songs
        }
    }
}

// swiftlint:enable nesting
