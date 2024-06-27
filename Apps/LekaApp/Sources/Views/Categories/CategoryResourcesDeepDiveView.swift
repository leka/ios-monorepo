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
            .padding(.horizontal)

            if self.category.content.map(\.resource).filter({ !$0.title.isEmpty }).isEmpty {
                VStack {
                    Text(l10n.CategoryResourcesDeepDiveView.emptyLabel)
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 150)
            } else {
                ResourceGridView(resources: self.category.content.map(\.resource))
            }
        }
        .navigationTitle(self.category.details.title)
    }

    // MARK: Private

    private let category: CategoryResources = ContentKit.deepDiveResources

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.CategoryResourcesDeepDiveView

extension l10n {
    enum CategoryResourcesDeepDiveView {
        static let emptyLabel = LocalizedString("lekaapp.category_resources_deep_dive_view.empty_label",
                                                value: "No resources yet",
                                                comment: "Empty label when no resources are available in the grid view.")
    }
}

#Preview {
    CategoryResourcesDeepDiveView()
}
