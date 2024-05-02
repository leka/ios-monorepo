// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// TODO: (@ladislas) move to UtilsKit
public extension Text {
    init(markdown: String) {
        self.init(.init(markdown))
    }
}
