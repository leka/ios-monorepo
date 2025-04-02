// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI
import UtilsKit

// MARK: - ListItem

public struct ListItem: View {
    // MARK: Lifecycle

    public init(_ content: CurationItemModel) {
        switch content.contentType {
            case .curriculum:
                guard let curriculum = Curriculum(id: content.id) else {
                    log.error("Content \(content.id) is labeled as curriculum but not decoded as such ")
                    return
                }
                self.contentType = .curriculum
                self.icon = curriculum.details.iconImage
                self.title = curriculum.details.title
                self.subtitle = curriculum.details.subtitle
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize)
            case .activity:
                guard let activity = Activity(id: content.id) else {
                    log.error("Content \(content.id) is labeled as activity but not decoded as such ")
                    return
                }
                self.contentType = .activity
                self.icon = activity.details.iconImage
                self.title = activity.details.title
                self.subtitle = activity.details.subtitle
                self.shape = Circle()
            case .story:
                guard let story = Story(id: content.id) else {
                    log.error("Content \(content.id) is labeled as story but not decoded as such ")
                    return
                }
                self.contentType = .story
                self.icon = story.details.iconImage
                self.title = story.details.title
                self.subtitle = story.details.subtitle
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize)
            default:
                log.error("Content \(content.id) is a curation and cannot be decoded as ListItem")
                return
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            Image(uiImage: self.icon)
                .resizable()
                .scaledToFit()
                .frame(width: self.kIconSize)
                .clipShape(AnyShape(self.shape))

            VStack(alignment: .leading) {
                Text(self.title)
                    .font(.body)

                Text(self.subtitle ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()

            Spacer()

            Button {} label: {
                Image(systemName: "ellipsis")
                    .bold()
            }
        }
        .frame(width: 350, height: 60)
        .contentShape(Rectangle())
    }

    // MARK: Private

    private var icon: UIImage = .init(systemName: "exclamationmark.triangle")!
    private var shape: any Shape = Rectangle()
    private let kIconSize: CGFloat = 60
    private var title: String = "Content not found"
    private var subtitle: String?
    private var contentType: ContentType = .activity
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", contentType: .activity),
        .init(id: "7C75908B86D748A283AA080D40642BE7", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", contentType: .activity),
        .init(id: "Wrong UUID", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", contentType: .curriculum),
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", contentType: .activity),
        .init(id: "7C75908B86D748A283AA080D40642BE7", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", contentType: .activity),
        .init(id: "Wrong UUID", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", contentType: .curriculum),
    ]

    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 30) {
            ForEach(curations.chunked(into: 3), id: \.self) { chunk in
                VStack {
                    ForEach(chunk) { curation in
                        ListItem(curation)
                        Divider()
                    }
                }
            }
        }
    }
}
