// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBarMarker: View {

    @Binding var color: Color
    @Binding var isCurrent: Bool

    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 3)
            .background(color, in: Circle())
            .overlay {
                Circle()
                    .fill(DesignKitAsset.Colors.chevron.swiftUIColor)
                    .padding(4)
                    .scaleEffect(isCurrent ? 1 : 0.01)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: isCurrent)
            }
    }
}
