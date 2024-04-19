// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Lottie
import SwiftUI

extension HideAndSeekView {
    struct HiddenView: View {
        let textSubInstructions: String

        var body: some View {
            VStack {
                Text(self.textSubInstructions)
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
    HideAndSeekView.HiddenView(
        textSubInstructions: """
            Incites la personne accompagnée à chercher Leka.
            Tu peux lancer un renforçateur pour lui donner
            un indice visuel et/ou sonore.
            Appuies sur TROUVÉ ! une fois le robot trouvé.
            """
    )
}
