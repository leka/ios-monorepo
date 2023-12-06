// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

enum DesignSystemApple {}
enum DesignSystemLeka {}

struct FontView: View {
    let font: Font

    var body: some View {
        VStack(alignment: .leading) {
            Text(fontName)
            Text("The quick brown fox jumps over the lazy dog")
        }
        .font(font)
    }

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

struct ColorSwiftUIView: View {
    @Environment(\.self) var environment

    let color: Color

    init(color: Color) {
        self.color = color
    }

    init(uiColor: UIColor) {
        self.color = Color(uiColor: uiColor)
    }

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
