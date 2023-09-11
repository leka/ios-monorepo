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
    @Binding var progress: Float

    var body: some View {
        VStack {
            Text("Envoi de la mise à jour vers le robot")
                .font(.title2)
                .bold()

            Gauge(value: progress, label: { EmptyView() })
                .tint(Color(red: 160 / 255, green: 185 / 255, blue: 49 / 255))
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
                Ne fermez pas l'application.
                """
            )
            .multilineTextAlignment(.center)
            .padding()
        }
    }
}

struct SendingFileView_Previews: PreviewProvider {
    @State static private var progress: Float = 0.66

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
                SendingFileContentView(progress: $progress)
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}
