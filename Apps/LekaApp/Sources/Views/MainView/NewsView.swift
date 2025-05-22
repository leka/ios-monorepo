// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - NewsView

struct NewsView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "lightbulb.max")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(l10n.NewsView.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(l10n.NewsView.subtitle)
                            .font(.title2)

                        Text(l10n.NewsView.description)
                            .foregroundStyle(.secondary)

                        Divider()
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                .padding()
            }
        }
    }

    // MARK: Private

    private var styleManager: StyleManager = .shared
}

// MARK: - l10n.NewsView

// swiftlint:disable line_length

extension l10n {
    enum NewsView {
        static let title = LocalizedString("lekaapp.news_view.title",
                                           value: "News",
                                           comment: "News title")

        static let subtitle = LocalizedString("lekaapp.news_view.subtitle",
                                              value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                              comment: "News subtitle")

        static let description = LocalizedString("lekaapp.news_view.description",
                                                 value: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                                                 comment: "News description")
    }
}

// swiftlint:enable line_length

#Preview {
    NewsView()
}
