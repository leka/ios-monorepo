// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

public class ContentKit {

    public var shared: ContentKit {
        ContentKit()
    }

    private init() {
        // nothing to do
    }

    public static func decodeActivity(_ filename: String) -> Activity {
        // swiftlint:disable force_try
        let data = try! String(
            contentsOfFile: Bundle.main.path(forResource: filename, ofType: "yml")!, encoding: .utf8)
        let activity = try! YAMLDecoder().decode(Activity.self, from: data)
        // swiftlint:enable force_try

        return activity
    }

}
