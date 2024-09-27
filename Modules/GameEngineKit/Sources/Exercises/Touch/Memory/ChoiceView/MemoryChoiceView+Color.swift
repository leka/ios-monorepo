// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

extension MemoryChoiceView {
    struct ColorView: View {
        // MARK: Lifecycle

        init(color: String, size: CGFloat, state: GameplayChoiceState = .idle) {
            self.color = Robot.Color(from: color)
            self.size = size
            self.state = state
        }

        // MARK: Internal

        @State var degree: Double = 90.0

        var choice: some View {
            self.color.screen
                .frame(
                    width: self.size,
                    height: self.size
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                .rotation3DEffect(Angle(degrees: self.degree), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
        }

        var body: some View {
            switch self.state {
                case .idle:
                    self.choice
                        .onAppear {
                            withAnimation(.linear(duration: self.kDurationAndDelay)) {
                                self.degree = 90.0
                            }
                        }

                case .selected,
                     .rightAnswer:
                    self.choice
                        .onAppear {
                            withAnimation(.linear(duration: self.kDurationAndDelay).delay(self.kDurationAndDelay)) {
                                self.degree = 0.0
                            }
                        }

                default:
                    EmptyView()
            }
        }

        // MARK: Private

        private let color: Robot.Color
        private let size: CGFloat
        private let state: GameplayChoiceState
        private let kDurationAndDelay: Double = 0.2
        private let nearZeroFloat: CGFloat = 0.0001
    }
}

#Preview {
    VStack(spacing: 50) {
        MemoryChoiceView.ColorView(color: "red", size: 200)
        MemoryChoiceView.ColorView(color: "red", size: 200, state: .selected)
        MemoryChoiceView.ColorView(color: "red", size: 200, state: .rightAnswer)
        MemoryChoiceView.ColorView(color: "red", size: 200, state: .wrongAnswer)
    }
}
