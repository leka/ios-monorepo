// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ChoiceType

enum ChoiceType {
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
                    SFSymbolView(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)

                case .text:
                    TextView(value: self.value, size: self.size)
                        .overlay(
                            Circle()
                                .fill(self.isTappable ? .clear : .white.opacity(0.6))
                        )
                        .animation(.easeOut(duration: 0.3), value: self.isTappable)
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
