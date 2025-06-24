// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - SendingFileIllustration

struct SendingFileIllustration: View {
    var body: some View {
        LekaUpdaterAsset.Assets.sendingUpdate.swiftUIImage
            .resizable()
            .scaledToFit()
    }
}

// MARK: - SendingFileContentView

struct SendingFileContentView: View {
    var progress: Float

    var body: some View {
        VStack {
            Text(l10n.update.sending.sendingTitle)
                .font(.title2)
                .bold()

            Gauge(value: self.progress, label: { EmptyView() })
                .tint(Color(red: 160 / 255, green: 185 / 255, blue: 49 / 255))
                .padding(40)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                        .shadow(radius: 3, y: 4)
                )
                .frame(width: 600)

            Text(l10n.update.sending.instructions)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

// MARK: - SendingFileView_Previews

struct SendingFileView_Previews: PreviewProvider {
    // MARK: Internal

    static var previews: some View {
        VStack {
            SendingFileIllustration()
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

            Text(l10n.update.stepNumber("1/3"))
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                SendingFileContentView(progress: progress)
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }

    // MARK: Private

    @State private static var progress: Float = 0.66
}
