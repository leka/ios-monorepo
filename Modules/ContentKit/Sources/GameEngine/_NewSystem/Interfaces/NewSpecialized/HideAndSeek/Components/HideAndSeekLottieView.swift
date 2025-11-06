// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import Lottie
import SwiftUI

struct HideAndSeekLottieView: View {
    // MARK: Internal

    var body: some View {
        ZStack(alignment: .top) {
            LottieView(animation: self.animation, speed: 0.5, loopMode: .loop)
                .resizable()

            Text(l10n.NewHideAndSeekView.instructionsLabel)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 70)
        }
        .background(.black)
        .ignoresSafeArea()
    }

    // MARK: Private

    private let animation = LottieAnimation.named("hide_and_seek_hidden.animation.lottie", bundle: .module)!
}

#Preview {
    HideAndSeekLottieView()
}
