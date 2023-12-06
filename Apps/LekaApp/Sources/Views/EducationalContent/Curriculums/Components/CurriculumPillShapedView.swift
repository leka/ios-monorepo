// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct CurriculumPillShapedView: View {
    @EnvironmentObject var metrics: UIMetrics

    var curriculum: Curriculum
    var icon: String

    var body: some View {
        VStack(spacing: 0) {
            topContent
            bottomContent
        }
        .frame(width: 200, height: 240)
        .background(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor, in: Rectangle())
        .clipShape(RoundedRectangle(cornerRadius: metrics.pillRadius, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
        .compositingGroup()
    }

    private var topContent: some View {
        Text(curriculum.fullTitle.localized())
            .multilineTextAlignment(.center)
            .font(metrics.med16)
            .frame(maxWidth: 136, minHeight: 120)
            .foregroundColor(.white)
    }

    private var bottomContent: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            iconView
            Spacer()
            Text("\(curriculum.activities.count) activités")
                .font(metrics.med12)
                .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
                .padding(.bottom, 12)
        }
        .background(Color.white, in: Rectangle())
    }

    private var iconView: some View {
        Image(icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 70)
    }
}
