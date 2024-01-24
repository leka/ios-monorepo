// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import Lottie
import SwiftUI

extension HideAndSeekView {
    struct HiddenView: View {
        var body: some View {
            VStack {
                Text(l10n.HideAndSeekView.Player.instructions)
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)

                LottieView(name: "hidden", speed: 0.5)
            }
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(10)
        }
    }
}

#Preview {
    HideAndSeekView.HiddenView()
}
