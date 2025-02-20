// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension ColorCoachView {
    struct ColorBar: View {
        // MARK: Internal

        let colors: [Robot.Color]
        let size: CGFloat

        var body: some View {
            HStack(spacing: 30) {
                ForEach(self.colors, id: \.screen) { color in
                    color.screen
                        .clipShape(Circle())
                        .frame(width: self.size, height: self.size)
                }
            }
            .padding()
            .background(self.backgroundColor)
            .clipShape(Capsule())
            .shadow(radius: 1)
        }

        // MARK: Private

        private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)
    }
}

#Preview {
    VStack(spacing: 50) {
        ColorCoachView.ColorBar(colors: [.red, .blue, .yellow], size: 100)

        ColorCoachView.ColorBar(colors: [.red, .blue, .yellow, .pink, .purple], size: 150)
    }
}
