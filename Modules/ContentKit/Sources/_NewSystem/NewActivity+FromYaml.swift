// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public extension NewActivity {
    init?(yaml yamlString: String) {
        if let activity = try? YAMLDecoder().decode(NewActivity.self, from: yamlString) {
            self = activity
        } else {
            return nil
        }
    }
}
