// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - RobotUpToDateIllustration

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
                    DesignKitAsset.Colors.lekaGreen.swiftUIColor, lineWidth: circleLineWidth
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
                        .foregroundColor(DesignKitAsset.Colors.lekaGreen.swiftUIColor)
                }
            }
        }
        .frame(width: circleSize, height: illustrationSize)
    }
}

// MARK: - RobotUpToDateIllustration_Previews

struct RobotUpToDateIllustration_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            Section {
                Group {
                    RobotUpToDateIllustration(size: 600)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(Color.clear)
        }
    }
}
