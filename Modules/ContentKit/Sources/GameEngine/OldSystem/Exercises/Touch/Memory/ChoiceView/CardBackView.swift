// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import RobotKit
import SwiftUI

struct CardBackView: View {
    // MARK: Lifecycle

    init(size: CGFloat, state: GameplayChoiceState = .idle) {
        guard let image = Bundle.path(forImage: "memory_back_of_cards") else {
            fatalError("Image not found")
        }
        self.image = image
        self.size = size
        self.state = state
    }

    // MARK: Internal

    @State var degree: Double = 0.0

    var choice: some View {
        Image(uiImage: UIImage(named: self.image)!)
            .resizable()
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
                        withAnimation(.linear(duration: self.kDurationAndDelay).delay(self.kDurationAndDelay)) {
                            self.degree = 0.0
                        }
                    }

            case .selected,
                 .rightAnswer:
                self.choice
                    .onAppear {
                        withAnimation(.linear(duration: self.kDurationAndDelay)) {
                            self.degree = -90.0
                        }
                    }

            default:
                EmptyView()
        }
    }

    // MARK: Private

    private let image: String
    private let size: CGFloat
    private let state: GameplayChoiceState
    private let kDurationAndDelay: Double = 0.2
    private let nearZeroFloat: CGFloat = 0.0001
}

#Preview {
    VStack(spacing: 50) {
        CardBackView(size: 200, state: .idle)
        CardBackView(size: 200, state: .selected)
        CardBackView(size: 200, state: .rightAnswer)
        CardBackView(size: 200, state: .wrongAnswer)
    }
}
