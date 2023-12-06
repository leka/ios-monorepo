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
            Text(fontName)
            Text("The quick brown fox jumps over the lazy dog")
        }
        .font(font)
    }

    // MARK: Private

    private var fontName: String {
        switch font {
            case .largeTitle:
                return "Large Title"
            case .title:
                return "Title"
            case .title2:
                return "Title 2"
            case .title3:
                return "Title 3"
            case .headline:
                return "Headline"
            case .subheadline:
                return "Subheadline"
            case .body:
                return "Body"
            case .callout:
                return "Callout"
            case .caption:
                return "Caption"
            case .caption2:
                return "Caption 2"
            case .footnote:
                return "Footnote"
            default:
                return "Unknown"
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
                Text("\(color.description): \(String(describing: color.resolve(in: environment).description))")
                Text("The quick brown fox jumps over the lazy dog")
            }
        }
        .foregroundColor(color)
    }
}
