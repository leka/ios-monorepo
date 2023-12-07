// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DesignSystemApple

enum DesignSystemApple {}

// MARK: - DesignSystemLeka

enum DesignSystemLeka {}

// MARK: - FontView

struct FontView: View {
    // MARK: Internal

    let font: Font

    var body: some View {
        VStack(alignment: .leading) {
            Text(self.fontName)
            Text("The quick brown fox jumps over the lazy dog")
        }
        .font(self.font)
    }

    // MARK: Private

    private var fontName: String {
        switch self.font {
            case .largeTitle:
                "Large Title"
            case .title:
                "Title"
            case .title2:
                "Title 2"
            case .title3:
                "Title 3"
            case .headline:
                "Headline"
            case .subheadline:
                "Subheadline"
            case .body:
                "Body"
            case .callout:
                "Callout"
            case .caption:
                "Caption"
            case .caption2:
                "Caption 2"
            case .footnote:
                "Footnote"
            default:
                "Unknown"
        }
    }
}

// MARK: - ColorSwiftUIView

struct ColorSwiftUIView: View {
    // MARK: Lifecycle

    init(color: Color) {
        self.color = color
    }

    init(uiColor: UIColor) {
        self.color = Color(uiColor: uiColor)
    }

    // MARK: Internal

    @Environment(\.self) var environment

    let color: Color

    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading) {
                Text("\(self.color.description): \(String(describing: self.color.resolve(in: self.environment).description))")
                Text("The quick brown fox jumps over the lazy dog")
            }
        }
        .foregroundColor(self.color)
    }
}
