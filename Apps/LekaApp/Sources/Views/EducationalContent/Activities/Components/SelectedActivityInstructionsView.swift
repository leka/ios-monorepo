// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SelectedActivityInstructionsView: View {
    // MARK: Internal

    @EnvironmentObject var activityVM: ActivityViewModel
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
                    .overlay { InstructionsView() }
                    .overlay { GoButton() }
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: Private

    private var activityDetailHeader: some View {
        HStack {
            Spacer()
            Text(self.activityVM.currentActivity.title.localized())
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: 420, height: 90)
    }
}
