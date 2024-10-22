// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - NewMemoryChoiceView

struct NewMemoryChoiceView: View {
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
                case .image:
                    NewMemoryChoiceViewImage(value: self.value, size: self.size)
                case .sfsymbol:
                    NewMemoryChoiceViewSFSymbol(value: self.value, size: self.size)
                case .text:
                    NewMemoryChoiceViewText(value: self.value, size: self.size)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: Private

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private var isTappable = true
}

// MARK: - NewMemoryChoiceViewDefaultIdle

struct NewMemoryChoiceViewDefaultIdle: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
    }

    // MARK: Internal

    @State var degreeCardBack: Double = -90.0
    @State var degreeCardFront: Double = 0.0

    var body: some View {
        ZStack {
            MemoryCardBackView(size: self.size)
                .rotation3DEffect(Angle(degrees: self.degreeCardBack), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
            NewMemoryChoiceView(value: self.value, type: self.type, size: self.size)
                .rotation3DEffect(Angle(degrees: self.degreeCardFront), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
        }
        .onAppear {
            withAnimation(.linear(duration: self.kDuration).delay(self.kDuration)) {
                self.degreeCardBack = 0.0
            }
            withAnimation(.linear(duration: self.kDuration)) {
                self.degreeCardFront = 90.0
            }
        }
    }

    // MARK: Private

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private let kDuration: Double = 0.2
    private let nearZeroFloat: CGFloat = 0.0001
}

// MARK: - NewMemoryChoiceViewDefaultSelectedOrCorrect

// swiftlint:disable:next type_name
struct NewMemoryChoiceViewDefaultSelectedOrCorrect: View {
    // MARK: Lifecycle

    init(value: String, type: ChoiceType, size: CGFloat) {
        self.value = value
        self.type = type
        self.size = size
    }

    // MARK: Internal

    @State var degreeCardBack: Double = 0.0
    @State var degreeCardFront: Double = 90.0

    var body: some View {
        ZStack {
            MemoryCardBackView(size: self.size)
                .rotation3DEffect(Angle(degrees: self.degreeCardBack), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
            NewMemoryChoiceView(value: self.value, type: self.type, size: self.size)
                .rotation3DEffect(Angle(degrees: self.degreeCardFront), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
        }
        .onAppear {
            withAnimation(.linear(duration: self.kDuration)) {
                self.degreeCardBack = -90.0
            }
            withAnimation(.linear(duration: self.kDuration).delay(self.kDuration)) {
                self.degreeCardFront = 0.0
            }
        }
    }

    // MARK: Private

    private let value: String
    private let type: ChoiceType
    private let size: CGFloat
    private let kDuration: Double = 0.2
    private let nearZeroFloat: CGFloat = 0.0001
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 40) {
            NewMemoryChoiceViewDefaultIdle(value: "Idle", type: .text, size: 200)
            NewMemoryChoiceViewDefaultSelectedOrCorrect(value: "Correct", type: .text, size: 200)
        }

        HStack(spacing: 40) {
            NewMemoryChoiceViewDefaultIdle(value: "dog", type: .sfsymbol, size: 200)
            NewMemoryChoiceViewDefaultSelectedOrCorrect(value: "Correct", type: .text, size: 200)
        }
    }
}
