// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BeltSectionView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color

    @State private var buttonPressed = false
    @State private var backgroundLineWidth = 0

    var body: some View {
        ArcShape(startAngle: startAngle, endAngle: endAngle, clockwise: true)
            .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .frame(width: 300, height: 300)
            .onTapGesture {
                buttonPressed.toggle()
                backgroundLineWidth = buttonPressed ? 20 : 0
            }

            .background(
                BeltSectionButtonFeedback(
                    startAngle: startAngle, endAngle: endAngle, color: color, lineWidth: backgroundLineWidth)
            )
            .animation(.easeIn(duration: 0.2), value: backgroundLineWidth)
    }
}

struct BeltSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BeltSectionView(startAngle: .degrees(0), endAngle: .degrees(180), color: .red)
    }
}
