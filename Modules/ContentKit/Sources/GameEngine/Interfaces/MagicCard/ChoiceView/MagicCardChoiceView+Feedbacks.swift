// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SwiftUI

// MARK: - MagicCardChoiceViewDefaultIdle

struct MagicCardChoiceViewDefaultIdle: View {
    // MARK: Lifecycle

    init(magicCard: MagicCard, size: CGFloat) {
        self.magicCard = magicCard
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        MagicCardChoiceView(magicCard: self.magicCard, size: self.size)
    }

    // MARK: Private

    @State private var bounce = false

    private let magicCard: MagicCard
    private let size: CGFloat
}

// MARK: - MagicCardChoiceViewDefaultCorrect

struct MagicCardChoiceViewDefaultCorrect: View {
    // MARK: Lifecycle

    init(magicCard: MagicCard, size: CGFloat) {
        self.magicCard = magicCard
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        MagicCardChoiceView(magicCard: self.magicCard, size: self.size)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .trim(from: 0.0, to: self.progress)
                    .stroke(Color.green, lineWidth: 5)
                    .frame(width: self.size, height: self.size * 0.625)
                    .rotationEffect(.degrees(-90))
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
            .onAppear {
                withAnimation(.spring(duration: 0.5)) {
                    self.progress = 1.0
                }
            }
    }

    // MARK: Private

    @State private var progress: CGFloat = 0.0

    private let magicCard: MagicCard
    private let size: CGFloat
}

// MARK: - MagicCardChoiceViewDefaultWrong

struct MagicCardChoiceViewDefaultWrong: View {
    // MARK: Lifecycle

    init(magicCard: MagicCard, size: CGFloat) {
        self.magicCard = magicCard
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        MagicCardChoiceView(magicCard: self.magicCard, size: self.size)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .opacity(self.overlayOpacity)
                    .frame(width: self.size * 0.625,
                           height: self.size)
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: Private

    @State private var overlayOpacity: CGFloat = 0.8

    private let magicCard: MagicCard
    private let size: CGFloat
}

// MARK: - MagicCardChoiceViewDefaultSelected

struct MagicCardChoiceViewDefaultSelected: View {
    // MARK: Lifecycle

    init(magicCard: MagicCard, size: CGFloat) {
        self.magicCard = magicCard
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        MagicCardChoiceView(magicCard: self.magicCard, size: self.size)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        .teal.opacity(self.opacity),
                        style: StrokeStyle(
                            lineWidth: self.lineWidth,
                            lineCap: .round,
                            dash: [15, 15]
                        )
                    )
                    .frame(width: self.size * 0.625, height: self.size)
                    .onAppear {
                        withAnimation(.spring(duration: 0.6)) {
                            self.lineWidth = 5.0
                        }
                    }
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: Private

    @State private var lineWidth: CGFloat = 0

    private let opacity: CGFloat = 0.7
    private let magicCard: MagicCard
    private let size: CGFloat
}

#Preview {
    VStack(spacing: 40) {
        MagicCardChoiceViewDefaultIdle(magicCard: MagicCard(name: "color_blue"), size: 200)
        MagicCardChoiceViewDefaultCorrect(magicCard: MagicCard(name: "color_red"), size: 200)
        MagicCardChoiceViewDefaultWrong(magicCard: MagicCard(name: "color_yellow"), size: 200)
        MagicCardChoiceViewDefaultSelected(magicCard: MagicCard(name: "color_purple"), size: 200)
    }
}
