// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct CurriculumPillShapedView: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    var curriculum: Curriculum
    var icon: String

    var body: some View {
        VStack(spacing: 0) {
            self.topContent
            self.bottomContent
        }
        .frame(width: 200, height: 240)
        .background(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, in: Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: self.metrics.pillRadius, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        .compositingGroup()
    }

    // MARK: Private

    private var topContent: some View {
        Text(self.curriculum.fullTitle.localized())
            .multilineTextAlignment(.center)
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.body)
            .frame(maxWidth: 136, minHeight: 120)
            .foregroundColor(.white)
    }

    private var bottomContent: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            self.iconView
            Spacer()
            Text("\(self.curriculum.activities.count) activités")
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.caption)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
                .padding(.bottom, 12)
        }
        .background(Color.white, in: Rectangle())
    }

    private var iconView: some View {
        Image(self.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 70)
    }
}
