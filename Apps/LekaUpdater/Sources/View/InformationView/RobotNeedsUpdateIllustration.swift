// Leka - iOS Monorepo
// Copyright APF France handicap
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
                .fill(.lkBackground)
                .frame(width: self.illustrationSize)

            Circle()
                .strokeBorder(
                    .yellow,
                    style: StrokeStyle(lineWidth: self.circleLineWidth, lineCap: .round, dash: [self.dashSpacer, self.dashSpacer])
                )
                .frame(width: self.circleSize)

            LekaUpdaterAsset.Assets.robotOnBase.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: self.imageSize)

            VStack {
                Spacer()

                ZStack {
                    Circle().fill(.lkBackground)
                        .frame(height: self.checkmarkSize)

                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: self.checkmarkSize))
                        .foregroundColor(.yellow)
                }
            }
        }
        .frame(width: self.circleSize, height: self.illustrationSize)
    }

    // MARK: Private

    private var circleSize: CGFloat {
        self.illustrationSize * 250 / 300
    }

    private var circleLineWidth: CGFloat {
        self.illustrationSize / 60
    }

    private var dashSpacer: CGFloat {
        self.illustrationSize / 18
    }

    private var imageSize: CGFloat {
        self.illustrationSize * 180 / 300
    }

    private var checkmarkSize: CGFloat {
        self.illustrationSize * 56 / 300
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
