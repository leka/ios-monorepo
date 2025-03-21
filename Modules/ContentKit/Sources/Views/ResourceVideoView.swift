// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import Combine
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
                                    origin: .resources
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

    let resource: Category.Resource

    // MARK: Private

    @State private var cancellable: AnyCancellable?
}

#Preview {
    NavigationStack {
        ResourceVideoView(
            resource: ContentKit.firstStepsResources.sections[0].resources.map(\.resource)[0]
        )
    }
}
