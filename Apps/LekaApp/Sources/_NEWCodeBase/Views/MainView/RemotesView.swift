// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - RemotesView

struct RemotesView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(l10n.RemotesView.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(l10n.RemotesView.subtitle)
                            .font(.title2)

                        Text(l10n.RemotesView.description)
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

    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.RemotesView

// swiftlint:disable line_length

extension l10n {
    enum RemotesView {
        static let title = LocalizedString("lekaapp.remotes_view.title",
                                           value: "Remotes",
                                           comment: "Remotes title")

        static let subtitle = LocalizedString("lekaapp.remotes_view.subtitle",
                                              value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                              comment: "Remotes subtitle")

        static let description = LocalizedString("lekaapp.remotes_view.description",
                                                 value: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                                                 comment: "Remotes description")
    }
}

// swiftlint:enable line_length

#Preview {
    RemotesView()
}
