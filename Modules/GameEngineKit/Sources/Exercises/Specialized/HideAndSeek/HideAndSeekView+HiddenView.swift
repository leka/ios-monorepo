// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import Lottie
import SwiftUI

extension HideAndSeekView {
    struct HiddenView: View {
        // MARK: Internal

        var body: some View {
            VStack {
                Text(l10n.HideAndSeekView.Player.instructions)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)

                LottieView(animation: self.animation, speed: 0.5)
            }
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(10)
        }

        // MARK: Private

        private let animation = LottieAnimation.named("hide_and_seek_hidden.animation.lottie", bundle: .module)!
    }
}

#Preview {
    HideAndSeekView.HiddenView()
}
