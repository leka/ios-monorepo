// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - MainCurations

enum MainCurations: String {
    case home = "F4E2C104C09E436CB80A87749CE62DDF"
    case explore = "60EE8932AE34449187E5B67646BEAEEF"
    case objectives = "29E4975B217F4DAEA99EE4E0DFCDB5BD"
    case sandbox = "4B476A0DFDC044B98DCBC631FF4EA27B"
    case curriculums = "2685B06A51324C31A255B50D8A2AD064"
    case educationalGames = "CBC96C481C3544B6A4F9A7DCAD1D13E9"
    case gamepads = "8FB0266E4DCE4295ADF8D14AA7493871"
    case stories = "EA36F26CEE7A495B878EB1285AFBA4D3"
}

// MARK: - CurationView

struct CurationView: View {
    // MARK: Lifecycle

    init(curation: CategoryCuration) {
        self.curation = curation
    }

    init(_ mainCuration: MainCurations) {
        guard let curation = ContentKit.allCurations[mainCuration.rawValue] else {
            fatalError("Curation not found for key: \(mainCuration.rawValue)")
        }
        self.curation = curation
    }

    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: true) {
            if self.curation.details.subtitle != "" {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: self.curation.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(self.curation.details.subtitle)
                            .font(.title2)

                        Text(self.curation.details.description)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .bottom])
            }

            VStack(alignment: .leading, spacing: 30) {
                ForEach(self.curation.sections) { section in
                    Section {
                        VStack(alignment: .leading, spacing: 5) {
                            if section.details.title != "" {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(section.details.title)
                                            .font(.title2)
                                            .foregroundStyle(self.styleManager.accentColor!)

                                        if section.details.subtitle != "" {
                                            Divider()

                                            Text(section.details.subtitle)
                                                .font(.headline)
                                        }

                                        Spacer()

                                        if section.items.count > 8 {
                                            NavigationLink(destination:
                                                CurationSeeMoreFactory(section: section)
                                                    .navigationTitle(section.details.title)
                                            ) {
                                                Text(l10n.SearchGridView.seeAllLabel)
                                            }
                                        }
                                    }
                                    if section.details.description != "" {
                                        Text(section.details.description)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(.horizontal)
                            }

                            CurationViewFactory(section: section)
                        }
                    }
                }
            }
        }
        .navigationTitle(self.curation.details.title)
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    private let curation: CategoryCuration
    private let kDividerPadding: CGFloat = 100
}

// MARK: - l10n.CurationView

extension l10n {
    enum CurationView {
        static let seeAllLabel = LocalizedString("lekaapp.curation_view.see_all_label",
                                                 value: "See all",
                                                 comment: "CurationView's 'See all' button label")
    }
}

#Preview {
    CurationView(curation: ContentKit.allCurations.first!.value)
}
