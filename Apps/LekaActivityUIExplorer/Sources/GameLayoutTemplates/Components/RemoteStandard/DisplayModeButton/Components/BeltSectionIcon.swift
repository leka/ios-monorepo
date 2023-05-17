// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BeltSectionIcon: View {
    var startAngle: Angle
    var endAngle: Angle

    @State private var backgroundLineWidth = 0

    var body: some View {
        ArcShape(startAngle: startAngle, endAngle: endAngle, clockwise: true)
            .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 60, height: 60)
    }
}

struct BeltSectionIcon_Previews: PreviewProvider {
    static var previews: some View {
        BeltSectionIcon(startAngle: .degrees(10), endAngle: .degrees(100))
    }
}
