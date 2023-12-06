// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension DesignSystemApple {

    struct FontsView: View {

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FontView(font: .largeTitle)
                    FontView(font: .title)
                    FontView(font: .title2)
                    FontView(font: .title3)
                    FontView(font: .headline)
                    FontView(font: .subheadline)
                    FontView(font: .body)
                    FontView(font: .callout)
                    FontView(font: .caption)
                    FontView(font: .caption2)
                    FontView(font: .footnote)
                }
            }
            .navigationTitle("Apple Fonts")
        }
    }
}

#Preview {
    DesignSystemApple.FontsView()
}
