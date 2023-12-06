// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityListCell: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    let activity: Activity
    let icon: String
    let iconDiameter: CGFloat = 132
    let rank: Int
    let selected: Bool

    var body: some View {
        HStack(spacing: 20) {
            iconView
            cellContent
            Spacer()
        }
        .frame(minWidth: 420, maxHeight: iconDiameter + 20)
        .background(selected ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .white)
        .clipShape(RoundedRectangle(cornerRadius: metrics.btnRadius, style: .continuous))
        .padding(.vertical, 4)
    }

    // MARK: Private

    private var iconView: some View {
        Image(icon)
            .activityIconImageModifier(diameter: iconDiameter)
            .padding(.leading, 10)
    }

    private var cellContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            Text(activity.title.localized())
                .font(metrics.reg19)
            Spacer()
            Group {
                Text("ACTIVITÉ \(rank)")
                    .font(metrics.bold15)
                    + Text(" - \(activity.short.localized())")
            }
            .font(metrics.reg15)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 10)
        }
        .foregroundColor(selected ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }
}
