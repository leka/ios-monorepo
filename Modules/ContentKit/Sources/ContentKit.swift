// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LogKit

let log = LogKit.createLoggerFor(module: "ContentKit")

// MARK: - ContentKit

public class ContentKit {
    // MARK: Lifecycle

    private init() {
        // nothing to do
    }

    // MARK: Public

    public var shared: ContentKit {
        ContentKit()
    }
}
