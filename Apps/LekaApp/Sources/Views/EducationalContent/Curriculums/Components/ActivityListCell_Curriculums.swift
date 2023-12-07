// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityListCell_Curriculums: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    let activity: Activity
    let icon: String
    let iconDiameter: CGFloat = 100
    let rank: Int
    let selected: Bool

    var body: some View {
        HStack(spacing: 20) {
            self.iconView
            self.cellContent
            Spacer()
        }
        .frame(minWidth: 420, maxHeight: self.iconDiameter + 20)
        .background(self.selected ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .white)
        .clipShape(RoundedRectangle(cornerRadius: self.metrics.btnRadius, style: .continuous))
        .padding(.vertical, 4)
    }

    // MARK: Private

    private var iconView: some View {
        Image(self.icon)
            .activityIconImageModifier(diameter: self.iconDiameter)
            .padding(.leading, 10)
    }

    private var cellContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
            Text(self.activity.title.localized())
                .font(self.metrics.reg19)
            Spacer()
            Group {
                Text("ACTIVITÉ \(self.rank)")
                    .font(self.metrics.bold15)
                    + Text(" - \(self.activity.short.localized())")
            }
            .font(self.metrics.reg15)
            .multilineTextAlignment(.leading)
            .padding(.bottom, 10)
        }
        .foregroundColor(self.selected ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }
}
