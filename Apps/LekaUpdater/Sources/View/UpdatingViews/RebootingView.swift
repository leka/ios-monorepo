// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - RebootingIllustration

struct RebootingIllustration: View {
    var body: some View {
        LekaUpdaterAsset.Assets.updateInstallation.swiftUIImage
            .resizable()
            .scaledToFit()
    }
}

// MARK: - RebootingContentView

struct RebootingContentView: View {
    var body: some View {
        VStack {
            Text(l10n.update.rebooting.rebootingTitle)
                .font(.title2)
                .bold()

            ProgressView()
                .scaleEffect(2)
                .padding()
                .padding()

            Text(l10n.update.rebooting.rebootingSubtitle)
        }
    }
}

// MARK: - RebootingView_Previews

struct RebootingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RebootingIllustration()
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

            Text(l10n.update.stepNumber("2/3"))
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                RebootingContentView()
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}
