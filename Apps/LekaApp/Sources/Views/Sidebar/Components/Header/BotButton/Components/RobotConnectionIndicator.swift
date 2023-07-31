// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotConnectionIndicator: View {

    @EnvironmentObject var robotVM: RobotViewModel
    // Animation
    @State private var isAnimated: Bool = false
    @State private var diameter: CGFloat = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(robotVM.robotIsConnected ? Color("lekaGreen") : Color("lekaDarkGray"))
                .opacity(0.4)

            Image(robotVM.robotIsConnected ?
                  LekaAppAsset.Assets.robotConnected.name : LekaAppAsset.Assets.robotDisconnected.name
            )
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44, alignment: .center)

            Circle()
                .stroke(
                    robotVM.robotIsConnected ? Color("lekaGreen") : Color("lekaDarkGray"),
                    lineWidth: 4
                )
                .frame(width: 44, height: 44)
        }
        .frame(width: 67, height: 67, alignment: .center)
        .background(
            Circle()
                .fill(Color("lekaGreen"))
                .frame(width: diameter, height: diameter)
                .opacity(isAnimated ? 0.0 : 0.8)
                .animation(
                    Animation.easeInOut(duration: 1.5).delay(5).repeatForever(autoreverses: false), value: diameter
                )
                .opacity(robotVM.robotIsConnected ? 1 : 0.0)
        )
        .onAppear {
            isAnimated = true
            diameter = isAnimated ? 100 : 0
        }
    }
}
