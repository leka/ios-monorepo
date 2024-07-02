// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension Bundle {
    func filenamesWithoutExtensions(forResourcesOfType: String, inDirectory: String?) -> [String] {
        let paths = paths(forResourcesOfType: forResourcesOfType, inDirectory: inDirectory)
        return paths.map(\.filenameWithoutExtension)
    }
}
