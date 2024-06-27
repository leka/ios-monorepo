// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CategoryResourcesFirstStepsView

struct CategoryResourcesFirstStepsView: View {
    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: true) {
            HStack(alignment: .center, spacing: 30) {
                Image(systemName: "shoeprints.fill")
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

            ResourceGridView(resources: self.category.content.map(\.resource))
        }
        .navigationTitle(self.category.details.title)
    }

    // MARK: Private

    private let category: CategoryResources = ContentKit.firstStepsResources

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    CategoryResourcesFirstStepsView()
}
