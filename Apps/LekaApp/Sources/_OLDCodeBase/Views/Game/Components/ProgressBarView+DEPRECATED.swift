// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ProgressBarViewDeprecated

struct ProgressBarViewDeprecated: View {
    @EnvironmentObject var activityVM: ActivityViewModelDeprecated
    @ObservedObject var gameMetrics: GameMetrics

    var body: some View {
        Capsule()
            .fill(DesignKitAsset.Colors.progressBar.swiftUIColor)
            .frame(maxHeight: self.gameMetrics.progressViewHeight)
            .frame(maxWidth: 760) // this will change
            .overlay(
                HStack(spacing: 0) {
                    ForEach(self.activityVM.steps.indices, id: \.self) { index in
                        self.stepMarker(self.activityVM.markerColors[index])
                        if index < self.activityVM.markerColors.count - 1 {
                            Spacer()
                        }
                    }
                }
            )
    }

    @ViewBuilder
    func stepMarker(_ color: Color) -> some View {
        Circle()
            .fillDeprecated(
                color,
                strokeBorder: .white,
                lineWidth: self.gameMetrics.stepMarkerBorderWidth
            )
            .background(Circle().fill(.white))
            .padding(self.gameMetrics.stepMarkerPadding)
    }
}

// MARK: - ProgressBarView_Previews

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarViewDeprecated(gameMetrics: GameMetrics())
            .environmentObject(ActivityViewModelDeprecated())
    }
}
