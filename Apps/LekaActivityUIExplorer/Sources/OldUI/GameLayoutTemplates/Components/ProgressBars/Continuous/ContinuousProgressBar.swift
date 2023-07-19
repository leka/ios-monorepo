// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ContinuousProgressBar: View {
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Capsule()
                .fill(defaults.progressBarBackgroundColor)
                .frame(height: 30)
                .frame(width: geometry.size.width)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(.green)
                        .frame(maxWidth: geometry.size.width * progress)
                        .padding(8)
                }
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        }
    }
}

struct ContinuousProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ContinuousProgressBar(progress: 0.4)
            .environmentObject(GameLayoutTemplatesDefaults())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
