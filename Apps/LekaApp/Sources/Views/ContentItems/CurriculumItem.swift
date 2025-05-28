// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CardItem

public struct CurriculumItem: View {
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
            default:
                log.error("Content \(content.id) is not a curriculum and cannot be decoded as CurriculumItem")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: self.icon)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: self.kIconSize)

            HStack {
                Text(self.title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)

                if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                    if self.libraryManagerViewModel.isContentFavorited(
                        by: currentCaregiverID,
                        contentID: self.curationItem.id
                    ) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(self.styleManager.accentColor ?? .blue)
                    }
                }
            }

            Text(self.subtitle ?? "")
                .font(.body)
                .foregroundStyle(Color.secondary)
        }
        .frame(width: self.kIconSize, alignment: .leading)
        .lineLimit(0)
        .fixedSize()
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var curationItem: CurationItemModel
    private var icon: UIImage
    private var title: String
    private var subtitle: String?
    private let kIconSize: CGFloat = 180

    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "CBBCDFA8DC8C462794904F6E5E0638AB", name: "", contentType: .activity),
        .init(id: "7C75908B86D748A283AA080D40642BE7", name: "", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "D91BDA161F8E455CA8A71881F1D2E923", name: "", contentType: .activity),
        .init(id: "Wrong UUID", name: "", contentType: .activity),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
    ]
    return ScrollView(.horizontal) {
        HStack {
            ForEach(curations) { curation in
                CurriculumItem(curation)
            }
        }
    }
    .padding()
}
