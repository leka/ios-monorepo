// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

struct FavoriteCurriculumsView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.items.isEmpty {
            EmptyFavoritesPlaceholderView(icon: .curriculums)
        } else {
            ScrollView(showsIndicators: true) {
                VerticalCurriculumGrid(items: self.items)
            }
        }
    }

    // MARK: Private

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var viewModel: SharedLibraryManagerViewModel

    private var items: [CurationItemModel] {
        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
            self.viewModel.curriculums.compactMap { savedCurriculum in
                guard self.viewModel.isCurriculumFavoritedByCurrentCaregiver(
                    curriculumID: savedCurriculum.id,
                    caregiverID: currentCaregiverID
                ), let curriculum = ContentKit.allPublishedCurriculums[savedCurriculum.id] else {
                    return nil
                }
                return CurationItemModel(id: curriculum.id, name: curriculum.name, contentType: .curriculum)
            }
            .sorted {
                $0.name.compare($1.name, locale: NSLocale.current) == .orderedAscending
            }
        } else {
            []
        }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    SharedLibraryCurriculumsView(viewModel: viewModel)
}
