// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CategoryResourcesDeepDiveView

struct CategoryResourcesDeepDiveView: View {
    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: true) {
            HStack(alignment: .center, spacing: 30) {
                Image(systemName: "paperclip")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(self.styleManager.accentColor!)

                VStack(alignment: .leading) {
                    Text(self.category.details.subtitle)
                        .font(.title2)

                    Text(self.category.details.description)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.bottom)

            VStack(alignment: .leading, spacing: 30) {
                ForEach(self.category.sections, id: \.id) { section in
                    Section {
                        VStack(alignment: .leading, spacing: 5) {
                            VStack(alignment: .leading) {
                                Text(section.details.title)
                                    .font(.title2)
                                    .foregroundStyle(self.styleManager.accentColor!)

                                Text(section.details.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)
                            .padding(.horizontal)

                            ResourceGridView(resources: section.resources.map(\.resource))

                            Divider()
                                .padding(.horizontal)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationTitle(self.category.details.title)
    }

    // MARK: Private

    private let category: CategoryResources = ContentKit.allResources["deep_dive"]!

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    CategoryResourcesDeepDiveView()
}
