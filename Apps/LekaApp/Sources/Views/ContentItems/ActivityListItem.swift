// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI
import UtilsKit

// MARK: - ActivityListItem

public struct ActivityListItem: View {
    // MARK: Lifecycle

    public init?(_ content: CurationItemModel, number: Int? = nil) {
        self.number = number
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
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize)
            default:
                log.error("Content \(content.id) is not an activity or a story and cannot be decoded as ActivityListItem")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            FavoriteListIcon(self.curationItem)

            if let number = self.number {
                Text("\(number + 1)")
                    .font(.headline)
                    .foregroundStyle(Color.secondary)
                    .padding(.trailing)
            }

            Image(uiImage: self.icon)
                .resizable()
                .scaledToFit()
                .frame(width: self.kIconSize)
                .clipShape(AnyShape(self.shape))

            VStack(alignment: .leading) {
                Text(self.title)
                    .foregroundStyle(Color.primary)

                Text(self.subtitle ?? "")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            if let activity = Activity(id: curationItem.id) {
                IconImageView(image: ContentKit.getGestureIconUIImage(for: activity))

                IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .ears))

                IconImageView(image: ContentKit.getFocusIconUIImage(for: activity, ofType: .robot))
            }
        }
        .frame(height: 60)
        .frame(minWidth: 100, maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    // MARK: Private

    private var curationItem: CurationItemModel
    private let number: Int?
    private var icon: UIImage
    private var shape: any Shape
    private let kIconSize: CGFloat = 50
    private var title: String
    private var subtitle: String?
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "Wrong UUID", name: "", contentType: .activity),
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
    ]

    ScrollView {
        ForEach(Array(curations.enumerated()), id: \.offset) { _, item in
            ActivityListItem(item)
        }
        .padding()
    }
}
