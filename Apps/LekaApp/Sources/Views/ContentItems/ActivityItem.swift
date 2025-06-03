// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import SwiftUI

// MARK: - ActivityItem

public struct ActivityItem: View {
    // MARK: Lifecycle

    public init?(_ content: CurationItemModel, size: CGFloat = 180) {
        self.iconSize = size
        switch content.contentType {
            case .activity:
                guard let activity = Activity(id: content.id) else {
                    log.error("Content \(content.id) is labeled as activity but not decoded as such ")
                    return nil
                }
                self.curationItem = content
                self.icon = activity.details.iconImage
                self.title = activity.details.title
                self.subtitle = activity.details.subtitle
                self.shape = Circle()
            case .story:
                guard let story = Story(id: content.id) else {
                    log.error("Content \(content.id) is labeled as story but not decoded as such ")
                    return nil
                }
                self.curationItem = content
                self.icon = story.details.iconImage
                self.title = story.details.title
                self.subtitle = story.details.subtitle
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.iconSize)
            default:
                log.error("Content \(content.id) is not an activity or a story and cannot be decoded as ActivityItem")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        VStack {
            Image(uiImage: self.icon)
                .resizable()
                .scaledToFit()
                .clipShape(AnyShape(self.shape))
                .frame(width: self.iconSize)

            HStack(spacing: 5) {
                Text(self.title)
                    .foregroundStyle(Color.primary)

                if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
                   self.sharedLibraryManagerViewModel.isContentFavorited(
                       by: currentCaregiverID,
                       contentID: self.curationItem.id
                   )
                {
                    Text(Image(systemName: "star.fill"))
                        .font(.caption)
                        .foregroundColor(self.styleManager.accentColor ?? .blue)
                }
            }

            Text(self.subtitle ?? " ")
                .font(.caption)
                .foregroundStyle(Color.secondary)

            Spacer()
        }
        .frame(width: self.width, alignment: .center)
        .lineLimit(0)
        .fixedSize()
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var curationItem: CurationItemModel
    private var icon: UIImage
    private var shape: any Shape
    private let iconSize: CGFloat
    private let width: CGFloat = 180
    private var title: String
    private var subtitle: String?

    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "7C75908B86D748A283AA080D40642BE7", name: "", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "Wrong UUID", name: "", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "7C75908B86D748A283AA080D40642BE7", name: "", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "Wrong UUID", name: "", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
    ]

    return VStack {
        ScrollView(.horizontal) {
            HStack {
                ForEach(curations) { curation in
                    ActivityItem(curation)
                }
            }
        }
        ScrollView(.horizontal) {
            HStack {
                ForEach(curations.shuffled()) { curation in
                    ActivityItem(curation, size: 120)
                }
            }
        }
    }
}
