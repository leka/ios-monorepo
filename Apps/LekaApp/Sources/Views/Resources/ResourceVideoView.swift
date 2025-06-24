// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import Combine
import ContentKit
import SwiftUI
import YouTubePlayerKit

// MARK: - ResourceVideoView

public struct ResourceVideoView: View {
    // MARK: Lifecycle

    public init(resource: ContentCategory.Resource) {
        self.resource = resource
    }

    // MARK: Public

    public var body: some View {
        GroupBox(label: Label(self.resource.title, systemImage: self.resource.icon)) {
            let player = YouTubePlayer(stringLiteral: self.resource.value)

            YouTubePlayerView(player)
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    self.cancellable = player.playbackStatePublisher
                        .sink { state in
                            if state == .playing {
                                AnalyticsManager.logEventSelectContent(
                                    type: .resourceVideo,
                                    id: self.resource.id.uuidString,
                                    name: self.resource.title,
                                    origin: Navigation.shared.selectedCategory?.rawValue
                                )
                            }
                        }
                }
                .onDisappear {
                    self.cancellable?.cancel()
                }
        }
        .padding()
    }

    // MARK: Internal

    let resource: ContentCategory.Resource

    // MARK: Private

    @State private var cancellable: AnyCancellable?
}

#Preview {
    NavigationStack {
        ResourceVideoView(
            resource: ContentKit.allResources.first!.value.sections[0].resources[0].resource
        )
    }
}
