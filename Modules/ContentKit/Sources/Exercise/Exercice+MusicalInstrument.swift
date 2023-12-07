// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

public enum MusicalInstrument {
    public struct Payload: Codable {
        // MARK: Lifecycle

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.instrument = try container.decode(String.self, forKey: .instrument)
            self.scale = try container.decode(String.self, forKey: .scale)
        }

        // MARK: Public

        public let instrument: String
        public let scale: String

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case instrument
            case scale
        }
    }
}
