// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: - DanceFreeze

public enum DanceFreeze {
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

        public func encode(to _: Encoder) throws {
            fatalError("Not implemented")
        }

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case songs
        }
    }
}
