// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct HiddenView: View {
    var body: some View {
        ZStack {
            Color(.black)

            VStack {
                Text(
                    """
                    Incites la personne accompagnée à chercher Leka.
                    Tu peux lancer un renforçateur pour lui donner
                    un indice visuel et/ou sonore.
                    Appuies sur **TROUVÉ !** une fois le robot trouvé.
                    """
                )
                .font(.title3)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 30)

                Spacer()
            }

            LottieView(name: "hidden", speed: 0.5)
        }
    }
}

struct HiddenView_Previews: PreviewProvider {
    static var previews: some View {
        HiddenView()
    }
}
