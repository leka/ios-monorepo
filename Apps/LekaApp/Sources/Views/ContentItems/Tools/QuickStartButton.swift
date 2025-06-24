// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - QuickStartButton

public struct QuickStartButton: View {
    // MARK: Lifecycle

    public init(item: CurationItemModel) {
        self.item = item
    }

    // MARK: Public

    public var body: some View {
        Button {
            switch self.item.contentType {
                case .activity:
                    guard let activity = Activity(id: self.item.id) else { return }
                    self.navigation.onStartActivity(activity)
                case .story:
                    guard let story = Story(id: self.item.id) else { return }
                    self.navigation.onStartStory(story)
                default:
                    break
            }
            AnalyticsManager.logEventActivityLaunch(id: self.item.id, name: self.item.name, origin: .listButton)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "play.fill")
                Text(l10n.QuickStartButton.playButtonLabel)
                    .font(.callout)
            }
            .foregroundColor(.lkGreen)
            .padding(.vertical, 5)
            .padding(.horizontal, 8)
            .overlay(
                Capsule()
                    .stroke(Color.lkGreen, lineWidth: 1)
            )
        }
    }

    // MARK: Internal

    let item: CurationItemModel

    // MARK: Private

    private var navigation: Navigation = .shared
}

// MARK: - l10n.QuickStartButton

extension l10n {
    enum QuickStartButton {
        static let playButtonLabel = LocalizedString("lekaapp.quick_start_button.play_button_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Play",
                                                     comment: "Play button label on QuickStartButton")
    }
}

#Preview {
    Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 24) {
        ForEach(1..<10) { index in
            GridRow {
                Text("Activity \(index)")
                Spacer()
                QuickStartButton(
                    item: CurationItemModel(id: "", name: "", contentType: .activity)
                )
            }
        }
    }
    .padding()
}
