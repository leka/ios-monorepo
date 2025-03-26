// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ResourceGridView

public struct ResourceGridView: View {
    // MARK: Lifecycle

    public init(resources: [Category.Resource]? = nil) {
        self.resources = resources ?? []
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(self.resources, id: \.id) { resource in
                if resource.title.isEmpty {
                    EmptyView()
                } else {
                    if resource.type == .file {
                        ResourceFileView(resource: resource)
                    } else {
                        ResourceVideoView(resource: resource)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: Internal

    let resources: [Category.Resource]

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    private let columns = Array(repeating: GridItem(), count: 2)
}

#Preview {
    NavigationStack {
        ResourceGridView(
            resources: ContentKit.firstStepsResources.sections[0].resources.map(\.resource)
        )
    }
}
