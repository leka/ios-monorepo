// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RebootingView: View {
    var body: some View {
        VStack {
            LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 250)

            Text("Votre robot va maintenant redémarrer")
                .font(.title3)
                .bold()

            Text("Étape 2/3")
                .padding()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Leka Updater")
                        .font(.title2)
                        .bold()
                    Text("L'application pour mettre à jour vos robots Leka !")
                }
            }
        }
    }
}

struct RebootingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RebootingView()
        }
    }
}
