// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import SwiftUI
import UtilsKit

// MARK: - FavoriteIcon

public struct FavoriteIcon: View {
    // MARK: Lifecycle

    public init(_ item: CurationItemModel) {
        self.curationItem = item
    }

    // MARK: Public

    public var body: some View {
        Group {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
               self.sharedLibraryManagerViewModel.isContentFavorited(
                   by: currentCaregiverID,
                   contentID: curationItem.id
               )
            {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(self.styleManager.accentColor ?? .blue)
            }
        }
    }

    // MARK: Internal

    let curationItem: CurationItemModel

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared
}

// MARK: - FavoriteListIcon

public struct FavoriteListIcon: View {
    // MARK: Lifecycle

    public init(_ item: CurationItemModel) {
        self.curationItem = item
    }

    // MARK: Public

    public var body: some View {
        Group {
            if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id,
               self.sharedLibraryManagerViewModel.isContentFavorited(
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
        }
    }

    // MARK: Internal

    let curationItem: CurationItemModel

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var styleManager: StyleManager = .shared
    private var sharedLibraryManagerViewModel: SharedLibraryManagerViewModel = .shared
}
