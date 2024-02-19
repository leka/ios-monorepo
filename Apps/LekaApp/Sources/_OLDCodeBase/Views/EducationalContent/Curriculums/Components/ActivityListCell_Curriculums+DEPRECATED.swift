// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityListCell_CurriculumsDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    let activity: ActivityDeprecated
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
                .font(.title2)
            Spacer()
            Group {
                Text("ACTIVITÉ \(self.rank)")
                    .font(.headline)
                    + Text(" - \(self.activity.short.localized())")
            }
            .multilineTextAlignment(.leading)
            .padding(.bottom, 10)
        }
        .foregroundColor(self.selected ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }
}
