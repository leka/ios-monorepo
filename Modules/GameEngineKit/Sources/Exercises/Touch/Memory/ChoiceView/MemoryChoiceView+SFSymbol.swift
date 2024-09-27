// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension MemoryChoiceView {
    struct SFSymbolView: View {
        // MARK: Lifecycle

        init(sfsymbol: String, size: CGFloat, state: GameplayChoiceState = .idle) {
            self.sfsymbol = sfsymbol
            self.size = size
            self.state = state
        }

        // MARK: Internal

        @State var degree: Double = 90.0

        // TODO(@ladislas): handle case of color white, add colored border?
        var choice: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(self.choiceBackgroundColor)
                .overlay {
                    if UIImage(systemName: self.sfsymbol) != nil {
                        Image(systemName: self.sfsymbol)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(0.5)
                    } else {
                        Text("❌\nSF Symbol not found:\n\(self.sfsymbol)")
                            .multilineTextAlignment(.center)
                            .frame(
                                width: self.size,
                                height: self.size
                            )
                            .overlay {
                                Circle()
                                    .stroke(Color.red, lineWidth: 5)
                            }
                    }
                }
                .foregroundStyle(.black)
                .frame(
                    width: self.size,
                    height: self.size
                )
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

        private let choiceBackgroundColor: Color = .init(
            light: .white,
            dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
        )

        private let sfsymbol: String
        private let size: CGFloat
        private let state: GameplayChoiceState
        private let kDurationAndDelay: Double = 0.2
        private let nearZeroFloat: CGFloat = 0.0001
    }
}

#Preview {
    VStack(spacing: 50) {
        MemoryChoiceView.SFSymbolView(sfsymbol: "🌨️", size: 200)
        MemoryChoiceView.SFSymbolView(sfsymbol: "🌨️", size: 200, state: .selected)
        MemoryChoiceView.SFSymbolView(sfsymbol: "☀️", size: 200, state: .rightAnswer)
        MemoryChoiceView.SFSymbolView(sfsymbol: "☀️", size: 200, state: .wrongAnswer)
    }
}
