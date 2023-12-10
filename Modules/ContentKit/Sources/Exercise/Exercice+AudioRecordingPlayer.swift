// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// swiftlint:disable nesting

public enum AudioRecordingPlayer {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let audioRecordingSongs: [AudioRecording.Song] = try container.decode(
                [AudioRecording.Song].self, forKey: .songs
            )
            self.songs = audioRecordingSongs.map { AudioRecording($0) }
        }

        // MARK: Public

        public let songs: [AudioRecording]

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case songs
        }
    }
}

// swiftlint:enable nesting
