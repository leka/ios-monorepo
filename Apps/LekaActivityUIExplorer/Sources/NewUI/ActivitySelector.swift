// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

enum CurrentActivity {
    case test, melody, hideAndSeek

    func title() -> String {
        switch self {
            case .test:
                return "Test activity"
            case .melody:
                return "Melody"
            case .hideAndSeek:
                return "Hide and Seek"
        }
    }
}

struct ActivitySelector: View {
    let activity: CurrentActivity

    var body: some View {
        switch activity {
            case .test:
                TestActivity()
            case .melody:
                MelodyActivity()
            case .hideAndSeek:
                HideAndSeekActivity()
        }
    }
}
