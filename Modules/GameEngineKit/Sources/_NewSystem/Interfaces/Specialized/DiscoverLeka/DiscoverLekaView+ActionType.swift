// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension DiscoverLekaView {
    enum ActionType {
        case start
        case pause
        case stop

        // MARK: Internal

        func icon(_ isPlaying: Bool) -> some View {
            let view = switch self {
                case .start:
                    Image(systemName: "play.circle.fill")
                        .foregroundStyle(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                        .font(.system(size: 150))
                case .pause:
                    Image(systemName: "pause.circle.fill")
                        .foregroundStyle(DesignKitAsset.Colors.btnDarkBlue.swiftUIColor)
                        .font(.system(size: 150))
                case .stop:
                    Image(systemName: "stop.circle.fill")
                        .foregroundStyle(
                            isPlaying
                                ? DesignKitAsset.Colors.lekaOrange.swiftUIColor
                                : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                        )
                        .font(.system(size: 150))
            }

            return view
        }
    }
}
