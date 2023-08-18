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
            Text("Sending the update to the robot")
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
                Do not unplug your robot.
                Do not take it out of its charging base.
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

            Text("Step 1/3")
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
