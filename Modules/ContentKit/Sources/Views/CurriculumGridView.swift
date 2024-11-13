// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurriculumGridView

public struct CurriculumGridView: View {
    // MARK: Lifecycle

    public init(curriculums: [Curriculum]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.curriculums = curriculums ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(self.curriculums) { curriculum in
                NavigationLink(
                    destination:
                    CurriculumDetailsView(
                        curriculum: curriculum,
                        onActivitySelected: self.onActivitySelected
                    )
                    .onAppear {
                        AnalyticsManager.shared.logEventSelectContent(
                            type: .curriculum,
                            id: curriculum.id,
                            name: curriculum.name,
                            origin: .personalLibrary
                        )
                    }
                ) {
                    CurriculumGroupboxView(curriculum: curriculum)
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let curriculums: [Curriculum]
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    NavigationStack {
        CurriculumGridView(
            curriculums: ContentKit.allCurriculums,
            onActivitySelected: { _ in
                print("Activity Selected")
            }
        )
    }
}
