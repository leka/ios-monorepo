// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import SwiftUI
import UtilsKit

// MARK: - ActivityDetailedListItem

public struct ActivityDetailedListItem: View {
    // MARK: Lifecycle

    public init(_ activity: Activity) {
        self.activity = activity
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
               self.libraryManagerViewModel.isContentFavorited(
                   by: currentCaregiverID,
                   contentID: self.activity.id
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

            Image(uiImage: self.activity.details.iconImage)
                .resizable()
                .scaledToFit()
                .frame(width: self.kIconSize)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(self.activity.details.title)
                    .font(.body)

                Text(self.activity.details.subtitle ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            IconImageView(image: ContentKit.getGestureIconUIImage(for: self.activity))

            IconImageView(image: ContentKit.getFocusIconUIImage(for: self.activity, ofType: .ears))

            IconImageView(image: ContentKit.getFocusIconUIImage(for: self.activity, ofType: .robot))

            IconImageView(image: ContentKit.getTemplateIconUIImage(for: self.activity))
        }
        .frame(height: 60)
        .frame(minWidth: 100, maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    // MARK: Internal

    let activity: Activity

    // MARK: Private

    private struct IconImageView: View {
        let image: UIImage?

        var body: some View {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.secondary)
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(.horizontal, 5)
            } else {
                Color.clear
                    .frame(width: 40, height: 40)
            }
        }
    }

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private let kIconSize: CGFloat = 60
    private var styleManager: StyleManager = .shared
    private var libraryManagerViewModel: LibraryManagerViewModel = .shared
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        VStack {
            ForEach(Array(ContentKit.allActivities.values)) { activity in
                ActivityDetailedListItem(activity)
                Divider()
            }
        }
    }
}
