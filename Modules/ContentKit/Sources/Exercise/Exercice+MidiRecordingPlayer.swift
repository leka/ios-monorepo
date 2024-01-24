// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public enum MidiRecordingPlayer {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.instrument = try container.decode(String.self, forKey: .instrument)

            let midiRecordingSongs = try container.decode([MidiRecording.Song].self, forKey: .songs)
            self.songs = midiRecordingSongs.map { MidiRecording($0) }
        }

        // MARK: Public

        public let instrument: String
        public let songs: [MidiRecording]

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case instrument
            case songs
        }
    }
}
