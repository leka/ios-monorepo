// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public extension View {
    func onTapGestureIf(_ condition: Bool, closure: @escaping () -> Void) -> some View {
        allowsHitTesting(condition)
            .onTapGesture {
                closure()
            }
    }
}
