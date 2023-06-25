// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RebootingIllustration: View {
    var body: some View {
        LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
            .resizable()
            .scaledToFit()
    }
}

struct RebootingContentView: View {
    var body: some View {
        VStack {
            Text("Installation de la mise à jour")
                .font(.title2)
                .bold()

            ProgressView()
                .scaleEffect(2)
                .padding()
                .padding()

            Text("Votre robot redémarrera dans quelques minutes")
        }
    }
}

struct RebootingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RebootingIllustration()
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

            Text("Étape 2/3")
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                RebootingContentView()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}
