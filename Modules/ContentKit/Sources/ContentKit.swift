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

    public enum ActivityList {
        public static let mixed: Activity = decodeActivity("activity-mixed")
        public static let seq1Selection: Activity = decodeActivity("activity-seq1-selection")
    }

    public static func decodeActivity(_ filename: String) -> Activity {
        // swiftlint:disable force_try
        let data = try! String(
            contentsOfFile: Bundle.module.path(forResource: filename, ofType: "yml")!, encoding: .utf8)
        let activity = try! YAMLDecoder().decode(Activity.self, from: data)
        // swiftlint:enable force_try

        return activity
    }

}
