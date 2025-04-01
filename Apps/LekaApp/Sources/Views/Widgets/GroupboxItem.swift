// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import SwiftUI

// MARK: - GroupboxItem

public struct GroupboxItem: View {
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
                self.activityCount = curriculum.activities.count
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * 150)
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
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * 150)
            default:
                log.error("Content \(content.id) is a curation and cannot be decoded as GroupboxItem")
        }
    }

    // MARK: Public

    public var body: some View {
        GroupBox {
            VStack {
                HStack {
                    Label(
                        self.contentType.label,
                        systemImage: self.contentType.icon
                    )
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    Spacer()

                    Button {} label: {
                        Image(systemName: "ellipsis")
                            .bold()
                    }
                }

                VStack(spacing: 10) {
                    Image(uiImage: self.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: self.kIconSize)
                        .clipShape(AnyShape(self.shape))

                    Text(self.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(self.subtitle ?? "")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    ZStack {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                        }

                        if let activityCount = self.activityCount {
                            Text(l10n.GroupboxItem.activityCountLabel(activityCount))
                                .font(.caption.bold())
                                .foregroundStyle(Color.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(width: 230, height: 300)
        }
    }

    // MARK: Private

    private var icon: UIImage = .init(systemName: "exclamationmark.triangle")!
    private var shape: any Shape = Rectangle()
    private var title: String = "Content not found"
    private var subtitle: String?
    private var activityCount: Int?
    private let kIconSize: CGFloat = 120
    private var contentType: CurationType = .activity
}

// MARK: - l10n.GroupboxItem

extension l10n {
    enum GroupboxItem {
        static let activityCountLabel = LocalizedStringInterpolation("content_kit.groupbox_item_view.activity_count_label",
                                                                     bundle: ContentKitResources.bundle,
                                                                     value: "%d activity",
                                                                     comment: "Activity count label of GroupboxItem")
    }
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
        HStack {
            ForEach(curations) { curation in
                GroupboxItem(curation)
            }
        }
    }
    .padding()
}
