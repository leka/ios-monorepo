// Leka - iOS Monorepo
// Copyright APF France handicap
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
            self.iconView
            self.cellContent
            Spacer()
        }
        .frame(minWidth: 420, maxHeight: self.iconDiameter + 20)
        .background(self.selected ? Color.accentColor : .white) // TODO: (@ui/ux) - nil might be better here
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
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.title2)
            Spacer()
            Group {
                Text("ACTIVITÉ \(self.rank)")
                    // TODO: (@ui/ux) - Design System - replace with Leka font
                    .font(.headline)
                    + Text(" - \(self.activity.short.localized())")
            }
            .multilineTextAlignment(.leading)
            .padding(.bottom, 10)
        }
        .foregroundColor(self.selected ? .white : Color.accentColor) // TODO: (@ui/ux) - nil might be better here
    }
}
