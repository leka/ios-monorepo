// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SendingFileView: View {
    @State private var progress = 0.66

    var body: some View {
        VStack {
            LekaUpdaterAsset.Assets.lekaUpdaterIcon.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding(.bottom)

            Text("La mise à jour est en cours...")
                .font(.title2)
                .bold()
            Text(
                """
                Ne débranchez pas votre robot.
                Veuillez à ce qu'il soit bien positionné sur son socle de recharge.
                """
            )
            .multilineTextAlignment(.center)
            .padding()

            Text("Étape 1/3")

            ProgressView(value: progress)
                .tint(Color(red: 160 / 255, green: 185 / 255, blue: 49 / 255))
                .scaleEffect(y: 2)
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                        .shadow(radius: 3, y: 4)
                )
                .frame(width: 600)
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

struct SendingFileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SendingFileView()
        }
    }
}
