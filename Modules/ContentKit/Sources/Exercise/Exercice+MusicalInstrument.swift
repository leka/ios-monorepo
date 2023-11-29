// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

public enum MusicalInstrument {

    public struct Payload: Codable {
        public let instrument: String
        public let scale: String

        enum CodingKeys: String, CodingKey {
            case instrument, scale
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.instrument = try container.decode(String.self, forKey: .instrument)
            self.scale = try container.decode(String.self, forKey: .scale)
        }
    }

}
