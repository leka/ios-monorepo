// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI
import UtilsKit

// MARK: - CarouselItem

public struct CarouselItem: View {
    // MARK: Lifecycle

    public init?(_ content: CurationItemModel) {
        switch content.contentType {
            case .curriculum:
                guard let curriculum = Curriculum(id: content.id) else {
                    log.error("Content \(content.id) is labeled as curriculum but not decoded as such ")
                    return nil
                }
                self.contentType = .curriculum
                self.icon = curriculum.details.iconImage
                self.title = curriculum.details.title
                self.subtitle = curriculum.details.subtitle
            case .activity:
                guard let activity = Activity(id: content.id) else {
                    log.error("Content \(content.id) is labeled as activity but not decoded as such ")
                    return nil
                }
                self.contentType = .activity
                self.icon = activity.details.iconImage
                self.title = activity.details.title
                self.subtitle = activity.details.subtitle
            case .story:
                guard let story = Story(id: content.id) else {
                    log.error("Content \(content.id) is labeled as story but not decoded as such ")
                    return nil
                }
                self.contentType = .story
                self.icon = story.details.iconImage
                self.title = story.details.title
                self.subtitle = story.details.subtitle
            default:
                log.error("Content \(content.id) is a curation and cannot be decoded as CarouselItem")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        VStack(alignment: .leading) {
            Label(
                self.contentType.label,
                systemImage: self.contentType.icon
            )
            .font(.subheadline)
            .foregroundColor(.gray)

            VStack(spacing: 0) {
                Image(uiImage: self.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 260)

                HStack {
                    VStack(alignment: .leading) {
                        Text(self.title)
                            .font(.callout.bold())
                            .foregroundStyle(.white)

                        Text(self.subtitle ?? "")
                            .font(.caption2)
                            .foregroundStyle(.white)

                        Spacer()
                    }

                    Spacer()
                }
                .padding()
                .background(
                    Color(uiColor: self.icon.averageColor!)
                )
                .frame(width: 260, height: 50)
                .fixedSize()
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    // MARK: Private

    private let icon: UIImage
    private let title: String
    private let subtitle: String?
    private let contentType: ContentType
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", contentType: .activity),
        .init(id: "7C75908B86D748A283AA080D40642BE7", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", contentType: .activity),
        .init(id: "Wrong UUID", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", contentType: .curriculum),
    ]
    return ScrollView(.horizontal) {
        HStack(spacing: 10) {
            ForEach(curations) { curation in
                CarouselItem(curation)
            }
        }
    }
}
