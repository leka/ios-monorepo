// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - RobotNeedsUpdateIllustration

struct RobotNeedsUpdateIllustration: View {
    // MARK: Lifecycle

    init(size: CGFloat = 300) {
        self.illustrationSize = size
    }

    // MARK: Public

    public var illustrationSize: CGFloat = 300

    // MARK: Internal

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: illustrationSize)

            Circle()
                .strokeBorder(
                    .yellow,
                    style: StrokeStyle(lineWidth: circleLineWidth, lineCap: .round, dash: [dashSpacer, dashSpacer])
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

                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: checkmarkSize))
                        .foregroundColor(.yellow)
                }
            }
        }
        .frame(width: circleSize, height: illustrationSize)
    }

    // MARK: Private

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
}

// MARK: - RobotNeedsUpdateIllustration_Previews

struct RobotNeedsUpdateIllustration_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            Section {
                Group {
                    RobotNeedsUpdateIllustration(size: 600)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(Color.clear)
        }
    }
}
