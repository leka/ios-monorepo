// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

struct SharedLibraryCurriculumsView: View {
    // MARK: Lifecycle

    init(viewModel: SharedLibraryManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        if self.items.isEmpty {
            EmptySharedLibraryPlaceholderView(icon: .curriculums)
        } else {
            ScrollView(showsIndicators: true) {
                VerticalCurriculumGrid(items: self.items)
            }
        }
    }

    // MARK: Private

    private var viewModel: SharedLibraryManagerViewModel

    private var items: [CurationItemModel] {
        self.viewModel.curriculums.compactMap { savedCurriculums in
            ContentKit.allCurriculums[savedCurriculums.id]
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
        .map { CurationItemModel(id: $0.id, name: $0.name, contentType: .curriculum) }
    }
}

#Preview {
    let viewModel = SharedLibraryManagerViewModel()
    SharedLibraryCurriculumsView(viewModel: viewModel)
}
