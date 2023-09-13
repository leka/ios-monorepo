// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SelectedActivityInstructionsView: View {

    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        ZStack(alignment: .top) {
            // NavigationBar color
            Color("lekaLightBlue").ignoresSafeArea()

            // Background Color (only visible under the header here)
            Color.accentColor

            VStack(spacing: 0) {
                activityDetailHeader
                Rectangle()
                    .fill(Color("lekaLightGray"))
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
