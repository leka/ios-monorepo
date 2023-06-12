// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TriangleButtonView: View {
    var color: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 200, height: 200)

            Button {
                // Move and turn on belt
            } label: {
                TriangleShape()
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineJoin: .round))
                    .background(TriangleShape().fill(color))
                    .frame(width: 100, height: 80)
            }
        }
    }
}

struct TriangleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleButtonView(color: .red)
    }
}
