// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - DanceFreezeModel

public struct DanceFreezeModel: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.songs = try container.decode([DanceFreeze.Song].self, forKey: .songs)
    }

    public init(data: Data) {
        guard let model = try? JSONDecoder().decode(DanceFreezeModel.self, from: data) else {
            log.error("Exercise payload not compatible with DanceFreeze model:\n\(String(data: data, encoding: .utf8) ?? "(no data)")")
            fatalError()
        }

        self = model
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case songs
    }

    let songs: [DanceFreeze.Song]
}
