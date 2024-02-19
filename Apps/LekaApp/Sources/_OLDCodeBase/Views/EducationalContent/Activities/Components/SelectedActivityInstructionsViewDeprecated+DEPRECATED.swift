// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SelectedActivityInstructionsViewDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var activityVM: ActivityViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack(alignment: .top) {
            // NavigationBar color
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            // Background Color (only visible under the header here)
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor

            VStack(spacing: 0) {
                self.activityDetailHeader
                Rectangle()
                    .fill(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)
                    .edgesIgnoringSafeArea(.bottom)
                    .overlay { InstructionsViewDeprecated() }
                    .overlay { GoButtonDeprecated() }
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: Private

    private var activityDetailHeader: some View {
        HStack {
            Spacer()
            Text(self.activityVM.currentActivity.title.localized())
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: 420, height: 90)
    }
}
