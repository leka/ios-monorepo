// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BeltSectionImage: View {
    var startAngle: Angle
    var endAngle: Angle

    @State private var buttonPressed = false
    @State private var backgroundLineWidth = 0

    var body: some View {
        Arc(startAngle: startAngle, endAngle: endAngle, clockwise: true)
            .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 60, height: 60)
    }
}

struct BeltSectionImage_Previews: PreviewProvider {
    static var previews: some View {
        BeltSectionImage(startAngle: .degrees(10), endAngle: .degrees(100))
    }
}
