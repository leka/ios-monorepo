// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI
import SwiftUIJoystick

struct JoystickView: View {
    // MARK: Public

    public var body: some View {
        VStack {
            JoystickBuilder(
                monitor: self.joystickViewViewModel.joystickMonitor,
                width: self.joystickViewViewModel.dragDiameter,
                shape: self.joystickViewViewModel.shape,

                background: {
                    ZStack {
                        Circle()
                            .fill(.white)
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.gray)

                        VStack(spacing: 110) {
                            Image(systemName: "arrow.up")
                                .foregroundColor(.gray.opacity(0.7))

                            HStack(spacing: 250) {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.gray.opacity(0.7))

                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.gray.opacity(0.7))
                            }

                            Image(systemName: "arrow.down")
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                },
                foreground: {
                    Circle()
                        .fill(.gray)
                },
                locksInPlace: false
            )
        }
    }

    // MARK: Private

    @StateObject private var joystickViewViewModel = JoystickViewViewModel(dragDiameter: 300)
}

#Preview {
    JoystickView()
}
