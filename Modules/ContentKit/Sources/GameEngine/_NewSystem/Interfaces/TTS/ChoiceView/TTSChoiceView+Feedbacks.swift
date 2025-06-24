// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - TTSChoiceViewDefaultIdle

struct TTSChoiceViewDefaultIdle: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        TTSChoiceView(value: self.value, type: self.type, size: self.size)
    }

    // MARK: Private

    @State private var bounce = false

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
}

// MARK: - TTSChoiceViewDefaultCorrect

struct TTSChoiceViewDefaultCorrect: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        TTSChoiceView(value: self.value, type: self.type, size: self.size)
            .overlay(
                Circle()
                    .trim(from: 0.0, to: self.progress)
                    .stroke(Color.green, lineWidth: 8)
                    .frame(width: self.size, height: self.size)
                    .rotationEffect(.degrees(-90))
            )
            .contentShape(Circle())
            .onAppear {
                withAnimation(.spring(duration: 0.5)) {
                    self.progress = 1.0
                }
            }
    }

    // MARK: Private

    @State private var progress: CGFloat = 0.0

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
}

// MARK: - TTSChoiceViewDefaultWrong

struct TTSChoiceViewDefaultWrong: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        TTSChoiceView(value: self.value, type: self.type, size: self.size)
            .overlay(
                Circle()
                    .fill(.gray)
                    .opacity(self.overlayOpacity)
                    .frame(width: self.size * self.kOverLayScaleFactor,
                           height: self.size * self.kOverLayScaleFactor)
            )
            .contentShape(Circle())
    }

    // MARK: Private

    @State private var overlayOpacity: CGFloat = 0.8

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private let kOverLayScaleFactor: CGFloat = 1.08
}

// MARK: - TTSChoiceViewDefaultSelected

struct TTSChoiceViewDefaultSelected: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        TTSChoiceView(value: self.value, type: self.type, size: self.size)
            .overlay(
                Circle()
                    .stroke(
                        .teal.opacity(self.opacity),
                        style: StrokeStyle(
                            lineWidth: self.lineWidth,
                            lineCap: .round,
                            dash: [15, 15]
                        )
                    )
                    .frame(width: self.size, height: self.size)
                    .onAppear {
                        withAnimation(.spring(duration: 0.6)) {
                            self.lineWidth = 8.0
                        }
                    }
            )
            .contentShape(Circle())
    }

    // MARK: Private

    @State private var lineWidth: CGFloat = 0

    private let opacity: CGFloat = 0.7
    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
}

// MARK: - TTSChoiceViewIconCorrect

struct TTSChoiceViewIconCorrect: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
        self.iconSize = size * 0.2
        self.iconPositionX = size - size * 0.1
        self.iconPositionY = size * 0.1
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            TTSChoiceView(value: self.value, type: self.type, size: self.size)

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .font(.largeTitle)
                .foregroundColor(.green)
                .scaleEffect(self.scale)
                .frame(width: self.size * 0.2, height: self.size * 0.2)
                .position(x: self.size - self.size * 0.1, y: self.size * 0.1)
                .onAppear {
                    withAnimation(.bouncy(duration: 0.3)) {
                        self.scale = 1.0
                    }
                }
        }
        .frame(width: self.size, height: self.size)
        .contentShape(Circle())
    }

    // MARK: Private

    @State private var scale: CGFloat = 0.1

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private let iconSize: CGFloat
    private let iconPositionX: CGFloat
    private let iconPositionY: CGFloat
}

// MARK: - TTSChoiceViewIconWrong

struct TTSChoiceViewIconWrong: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
        self.iconSize = size * 0.2
        self.iconPositionX = size - size * 0.1
        self.iconPositionY = size * 0.1
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            TTSChoiceView(value: self.value, type: self.type, size: self.size)

            Image(systemName: "xmark.circle.fill")
                .resizable()
                .font(.largeTitle)
                .foregroundColor(.red)
                .scaleEffect(self.scale)
                .frame(width: self.size * 0.2, height: self.size * 0.2)
                .position(x: self.size - self.size * 0.1, y: self.size * 0.1)
                .onAppear {
                    withAnimation(.bouncy(duration: 0.3)) {
                        self.scale = 1.0
                    }
                }
        }
        .frame(width: self.size, height: self.size)
        .contentShape(Circle())
    }

    // MARK: Private

    @State private var scale: CGFloat = 0.1

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private let iconSize: CGFloat
    private let iconPositionX: CGFloat
    private let iconPositionY: CGFloat
}

// MARK: - TTSChoiceViewIconSelected

struct TTSChoiceViewIconSelected: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
        self.iconSize = size * 0.2
        self.iconPositionX = size - size * 0.1
        self.iconPositionY = size * 0.1
    }

    // MARK: Internal

    var body: some View {
        ZStack {
            TTSChoiceView(value: self.value, type: self.type, size: self.size)

            Image(systemName: "circle.dotted.circle")
                .font(.largeTitle)
                .foregroundStyle(.teal)
                .scaleEffect(self.scale)
                .frame(width: self.size * 0.2, height: self.size * 0.2)
                .position(x: self.size - self.size * 0.1, y: self.size * 0.1)
                .onAppear {
                    withAnimation(.bouncy(duration: 0.3)) {
                        self.scale = 1.0
                    }
                }
        }
        .frame(width: self.size, height: self.size)
        .contentShape(Circle())
    }

    // MARK: Private

    @State private var scale: CGFloat = 0.1

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private let iconSize: CGFloat
    private let iconPositionX: CGFloat
    private let iconPositionY: CGFloat
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 40) {
            TTSChoiceViewDefaultIdle(value: "Idle", type: .text, size: 200)
            TTSChoiceViewDefaultCorrect(value: "Correct", type: .text, size: 200)
            TTSChoiceViewDefaultWrong(value: "Wrong", type: .text, size: 200)
            TTSChoiceViewDefaultSelected(value: "Selected", type: .text, size: 200)
        }

        HStack(spacing: 40) {
            TTSChoiceViewDefaultIdle(value: "dog", type: .sfsymbol, size: 200)
            TTSChoiceViewIconCorrect(value: "cat", type: .sfsymbol, size: 200)
            TTSChoiceViewIconWrong(value: "fish", type: .sfsymbol, size: 200)
            TTSChoiceViewIconSelected(value: "bird", type: .sfsymbol, size: 200)
        }
    }
}
