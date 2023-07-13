// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SendingFileIllustration: View {
    var body: some View {
        LekaUpdaterAsset.Assets.sendingUpdate.swiftUIImage
            .resizable()
            .scaledToFit()
    }
}

struct SendingFileContentView: View {
    @State private var progress = 0.66

    var body: some View {
        VStack {
            Text("Envoi de la mise à jour vers le robot")
                .font(.title2)
                .bold()

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

            Text(
                """
                Ne débranchez pas votre robot.
                Ne le sortez pas de son socle de recharge.
                """
            )
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

struct SendingFileView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SendingFileIllustration()
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

            Text("Étape 1/3")
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                SendingFileContentView()
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}
