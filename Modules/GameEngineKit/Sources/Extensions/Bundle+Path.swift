// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation

// TODO: (@ladislas) move to UtilsKit
public extension Bundle {
    static func path(forImage image: String, in bundle: Bundle? = nil) -> String? {
        let kImageExtensions = ["png", "jpg", "jpeg", "svg"]

        for imageExtension in kImageExtensions {
            if let path = bundle?.path(forResource: image, ofType: imageExtension) {
                return path
            }

            if let path = Bundle.module.path(forResource: image, ofType: imageExtension) {
                return path
            }

            if let path = Bundle.main.path(forResource: image, ofType: imageExtension) {
                return path
            }
        }

        return nil
    }
}
