// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ChoiceType

enum ChoiceType {
    case image
    case sfsymbol
    case text
}

// MARK: - TTSChoiceView

struct TTSChoiceView: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat, isTappable: Bool = true) {
        self.value = value
        self.type = type
        self.size = size
        self.isTappable = isTappable
    }

    // MARK: Internal

    var body: some View {
        Group {
            switch self.type {
                case .sfsymbol:
                    TTSChoiceViewSFSymbol(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .text:
                    TTSChoiceViewText(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)
                default:
                    EmptyView()
            }
        }
        .contentShape(Circle())
    }

    // MARK: Private

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private var isTappable = true
}

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
        ZStack {
            TTSChoiceView(value: self.value, type: self.type, size: self.size)

            Image(systemName: "xmark.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
                .scaleEffect(self.scale)
                .position(x: self.size - 20, y: 20)
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
        ZStack {
            TTSChoiceView(value: self.value, type: self.type, size: self.size)

            Image(systemName: "circle.dotted.circle")
                .font(.largeTitle)
                .foregroundStyle(.teal)
                .scaleEffect(self.scale)
                .position(x: self.size - 20, y: 20)
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
            TTSChoiceViewDefaultCorrect(value: "cat", type: .sfsymbol, size: 200)
            TTSChoiceViewDefaultWrong(value: "fish", type: .sfsymbol, size: 200)
            TTSChoiceViewDefaultSelected(value: "bird", type: .sfsymbol, size: 200)
        }
    }
}
