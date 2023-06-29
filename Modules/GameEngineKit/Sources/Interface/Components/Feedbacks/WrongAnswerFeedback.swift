// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct WrongAnswerFeedback: View {
    public var overlayOpacity: CGFloat

    public var body: some View {
        Circle()
            .fill(.gray)
            .opacity(overlayOpacity)
    }
}
