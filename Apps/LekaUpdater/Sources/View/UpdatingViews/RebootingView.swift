// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RebootingIllustration: View {
    var body: some View {
        LekaUpdaterAsset.Assets.updateInstallation.swiftUIImage
            .resizable()
            .scaledToFit()
    }
}

struct RebootingContentView: View {
    var body: some View {
        VStack {
            Text("Installing the update")
                .font(.title2)
                .bold()

            ProgressView()
                .scaleEffect(2)
                .padding()
                .padding()

            Text("Your robot will restart in a few minutes")
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

            Text("Step 2/3")
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
