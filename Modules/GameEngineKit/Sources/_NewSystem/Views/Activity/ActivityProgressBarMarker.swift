// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBarMarker: View {
    @Binding var color: Color
    @Binding var isCurrentlyPlaying: Bool

    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 3)
            .background(self.color, in: Circle())
            .overlay {
                Circle()
                    .fill(DesignKitAsset.Colors.chevron.swiftUIColor)
                    .padding(4)
                    .scaleEffect(self.isCurrentlyPlaying ? 1 : 0.01)
                    .animation(.easeIn(duration: 0.5).delay(0.2), value: self.isCurrentlyPlaying)
            }
    }
}
