// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI
import YouTubePlayerKit

// MARK: - ResourceVideoView

public struct ResourceVideoView: View {
    // MARK: Lifecycle

    public init(resource: Category.Resource) {
        self.resource = resource
    }

    // MARK: Public

    public var body: some View {
        GroupBox(label: Label(self.resource.title, systemImage: self.resource.icon)) {
            YouTubePlayerView(YouTubePlayer(stringLiteral: self.resource.value))
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }

    // MARK: Internal

    let resource: Category.Resource
}

#Preview {
    NavigationStack {
        ResourceVideoView(
            resource: ContentKit.firstStepsResources.sections[0].resources.map(\.resource)[0]
        )
    }
}
