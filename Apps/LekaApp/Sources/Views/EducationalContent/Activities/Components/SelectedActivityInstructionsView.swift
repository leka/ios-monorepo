// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SelectedActivityInstructionsView: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack(alignment: .top) {
            // NavigationBar color
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            // Background Color (only visible under the header here)
            DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor

            VStack(spacing: 0) {
                activityDetailHeader
                Rectangle()
                    .fill(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)
                    .edgesIgnoringSafeArea(.bottom)
                    .overlay { InstructionsView() }
                    .overlay { GoButton() }
            }
        }
        .preferredColorScheme(.light)
    }

    private var activityDetailHeader: some View {
        HStack {
            Spacer()
            Text(activityVM.currentActivity.title.localized())
                .font(metrics.semi17)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: 420, height: 90)
    }
}
