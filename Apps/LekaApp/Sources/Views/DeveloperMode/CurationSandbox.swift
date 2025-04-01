// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurationSandbox

struct CurationSandbox: View {
    // MARK: Lifecycle

    init(curation: CategoryCuration) {
        self.curation = curation
    }

    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(alignment: .leading, spacing: 30) {
                ForEach(self.curation.sections) { section in
                    Section {
                        VStack(alignment: .leading, spacing: 5) {
                            VStack(alignment: .leading) {
                                Text(section.details.title)
                                    .font(.title2)
                                    .foregroundStyle(self.styleManager.accentColor!)

                                if section.details.subtitle != "" {
                                    Text(section.details.subtitle)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding()

                            WidgetFactory(section: section)
                                .padding(.horizontal)
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
}

#Preview {
    CurationSandbox(curation: ContentKit.allCurations[0])
}
