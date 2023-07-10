// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotUpToDateIllustration: View {
    public var illustrationSize: CGFloat = 300

    private var circleSize: CGFloat {
        illustrationSize * 250 / 300
    }
    private var circleLineWidth: CGFloat {
        illustrationSize / 60
    }
    private var dashSpacer: CGFloat {
        illustrationSize / 18
    }
    private var imageSize: CGFloat {
        illustrationSize * 180 / 300
    }
    private var checkmarkSize: CGFloat {
        illustrationSize * 56 / 300
    }

    init(size: CGFloat = 300) {
        self.illustrationSize = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: illustrationSize)

            Circle()
                .strokeBorder(
                    DesignKitAsset.Colors.lekaUpdaterRobotUpToDate.swiftUIColor, lineWidth: circleLineWidth
                )
                .frame(width: circleSize)

            LekaUpdaterAsset.Assets.robotOnBase.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: imageSize)

            VStack {
                Spacer()

                ZStack {
                    Circle().fill(.white)
                        .frame(height: checkmarkSize)

                    Image(systemName: "checkmark.circle")
                        .font(.system(size: checkmarkSize))
                        .foregroundColor(DesignKitAsset.Colors.lekaUpdaterRobotUpToDate.swiftUIColor)
                }
            }
        }
        .frame(width: circleSize, height: illustrationSize)
    }
}

struct RobotUpToDateIllustration_Previews: PreviewProvider {
    static var previews: some View {
        RobotUpToDateIllustration(size: 600)
    }
}
