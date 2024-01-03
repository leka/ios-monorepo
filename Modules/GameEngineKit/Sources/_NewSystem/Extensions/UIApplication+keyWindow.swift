// Leka - iOS Monorepo
// Copyright 2024 APF France handicap
// SPDX-License-Identifier: Apache-2.0

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes
        self.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap { $0 as? UIWindowScene }?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }

    func dismissAll(animated: Bool, completion: (() -> Void)? = nil) {
        self.keyWindow?.rootViewController?.dismiss(animated: animated, completion: completion)
    }
}
