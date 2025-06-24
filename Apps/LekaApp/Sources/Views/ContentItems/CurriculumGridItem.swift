// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - CurriculumGridItem

public struct CurriculumGridItem: View {
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
                log.error("Content \(content.id) is not a curriculum and cannot be decoded as CurriculumGridItem")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            FavoriteListIcon(self.curationItem)

            Image(uiImage: self.icon)
                .resizable()
                .scaledToFit()
                .frame(width: self.kIconSize)
                .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize))

            VStack(alignment: .leading) {
                Text(self.title)
                    .foregroundStyle(Color.primary)

                Text(self.subtitle ?? "")
                    .font(.caption)
                    .foregroundColor(Color.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal)

            Spacer()

            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                ContentItemMenu(self.curationItem, caregiverID: currentCaregiverID)
            }
        }
        .frame(width: 310, height: self.kIconSize)
        .contentShape(Rectangle())
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var curationItem: CurationItemModel
    private var icon: UIImage
    private let kIconSize: CGFloat = 100
    private var title: String
    private var subtitle: String?
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "7C75908B86D748A283AA080D40642BE7", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "Wrong UUID", name: "", contentType: .curriculum),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
        .init(id: "7C75908B86D748A283AA080D40642BE7", name: "", contentType: .curriculum),
        .init(id: "60C133CB19F94BA0864DFA9BF6E7F696", name: "", contentType: .story),
        .init(id: "B6F2027A304C44F5B3C482EAFCD8DE7E", name: "", contentType: .curriculum),
    ]

    ScrollView {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: Array(repeating: GridItem(), count: 2), spacing: 10) {
                ForEach(Array(curations.enumerated()), id: \.offset) { index, item in
                    VStack {
                        CurriculumGridItem(item)
                        let isNotLast = ((index + 1) % 2) != 0
                        if isNotLast {
                            Divider()
                                .padding(.leading, 150)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
