// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum Reinforcer: String, CaseIterable {
    case blinkGreen = "reinforcer-1"
    case spinBlink = "reinforcer-2"
    case fire = "reinforcer-3"
    case sparkles = "reinforcer-4"
    case rainbow = "reinforcer-5"
}

enum DisplayMode: String, CaseIterable {
    case fullBelt
    case twoHalves
    case fourQuarters
}

struct RadialLayout: Layout {
    var firstButtonPosX: Int
    var firstButtonPosY: Int
    var angle: Double

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {

        let angle = Angle.degrees(angle / Double(subviews.count - 1)).radians
        let posX = bounds.midX
        let posY = bounds.midY * 4 / 3

        for (index, subview) in subviews.enumerated() {
            if index == 0 {
                subview.place(
                    at: CGPoint(x: posX, y: posY), anchor: .center, proposal: .unspecified
                )
            } else {
                var point = CGPoint(x: firstButtonPosX, y: firstButtonPosY)
                    .applying(CGAffineTransform(rotationAngle: CGFloat(angle) * CGFloat(index - 1)))

                point.x += posX
                point.y += posY

                subview.place(at: point, anchor: .center, proposal: .unspecified)
            }
        }
    }
}

struct RemoteStandardView: View {

    @ObservedObject var templateDefaults: BaseDefaults
    @State private var displayMode = DisplayMode.fullBelt

    @State private var buttonPressed = false
    @State private var backgroundDimension = 0

    var body: some View {
        VStack {
            StepInstructionsButton()

            HStack(spacing: 400) {
                RadialLayout(firstButtonPosX: -100, firstButtonPosY: -250, angle: 120.0) {
                    JoystickView()

                    ForEach(Reinforcer.allCases, id: \.self) { reinforcer in
                        ReinforcerButton(reinforcer: reinforcer)
                    }
                }

                RadialLayout(firstButtonPosX: -120, firstButtonPosY: -200, angle: 90.0) {
                    switch displayMode {
                        case .fullBelt:
                            FullBeltSelector()
                        case .twoHalves:
                            TwoHalvesSelector()
                        case .fourQuarters:
                            FourQuartersSelector()
                    }

                    ForEach(DisplayMode.allCases, id: \.self) { mode in
                        DisplayModeButton(mode: mode, displayMode: $displayMode)
                    }
                }
            }
            .padding(0)
        }
    }
}
