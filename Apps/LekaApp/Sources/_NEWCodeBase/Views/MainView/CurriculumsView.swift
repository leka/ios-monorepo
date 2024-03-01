// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurriculumsView

struct CurriculumsView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "graduationcap")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(l10n.CurriculumsView.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text(l10n.CurriculumsView.subtitle)
                            .font(.title2)

                        Text(l10n.CurriculumsView.description)
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

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.CurriculumsView

// swiftlint:disable line_length

extension l10n {
    enum CurriculumsView {
        static let title = LocalizedString("lekaapp.curriculums_view.title",
                                           value: "Curriculums",
                                           comment: "Curriculums title")

        static let subtitle = LocalizedString("lekaapp.curriculums_view.subtitle",
                                              value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                              comment: "Curriculums subtitle")

        static let description = LocalizedString("lekaapp.curriculums_view.description",
                                                 value: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                                                 comment: "Curriculums description")
    }
}

// swiftlint:enable line_length

#Preview {
    CurriculumsView()
}