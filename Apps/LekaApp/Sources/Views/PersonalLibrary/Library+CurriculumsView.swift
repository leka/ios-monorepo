// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import LocalizationKit
import SwiftUI

struct LibraryCurriculumsView: View {
    // MARK: Lifecycle

    init(viewModel: RootAccountManagerViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Internal

    var body: some View {
        ScrollView(showsIndicators: true) {
            CurriculumGridView(curriculums: self.curriculums) { _ in
                // Nothing to do
            }
        }
    }

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var viewModel: RootAccountManagerViewModel

    private var curriculums: [Curriculum] {
        self.viewModel.savedCurriculums.compactMap { savedCurriculums in
            ContentKit.allCurriculums.first { $0.id == savedCurriculums.id }
        }
        .sorted {
            $0.details.title.compare($1.details.title, locale: NSLocale.current) == .orderedAscending
        }
    }
}

#Preview {
    let viewModel = RootAccountManagerViewModel()
    LibraryCurriculumsView(viewModel: viewModel)
}
