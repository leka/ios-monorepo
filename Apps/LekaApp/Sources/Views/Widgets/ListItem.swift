// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import SwiftUI
import UtilsKit

// MARK: - ListItem

public struct ListItem: View {
    // MARK: Lifecycle

    public init?(_ content: CurationItemModel) {
        switch content.contentType {
            case .curriculum:
                guard let curriculum = Curriculum(id: content.id) else {
                    log.error("Content \(content.id) is labeled as curriculum but not decoded as such ")
                    return nil
                }
                self.curationItem = content
                self.icon = curriculum.details.iconImage
                self.title = curriculum.details.title
                self.subtitle = curriculum.details.subtitle
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize)
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
                log.error("Content \(content.id) is a curation and cannot be decoded as ListItem")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
               self.libraryManagerViewModel.isContentFavorited(
                   by: currentCaregiverID,
                   contentID: curationItem.id
               )
            {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(self.styleManager.accentColor ?? .blue)
                    .frame(width: 10)
                    .padding(.trailing)
            } else {
                Color.clear
                    .frame(width: 10)
                    .padding(.trailing)
            }

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

            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ContentItemMenu(self.curationItem, caregiverID: currentCaregiverID)
            }
        }
        .frame(height: 60)
        .frame(minWidth: 200, maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    // MARK: Private

    @StateObject private var styleManager: StyleManager = .shared
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var curationItem: CurationItemModel
    private var icon: UIImage
    private var shape: any Shape
    private let kIconSize: CGFloat = 60
    private var title: String
    private var subtitle: String?

    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
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
