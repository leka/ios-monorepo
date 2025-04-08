// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - CurriculumGridView

public struct CurriculumGridView: View {
    // MARK: Lifecycle

    public init(curriculums: [Curriculum]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.curriculums = curriculums ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns, spacing: 20) {
            ForEach(self.curriculums) { curriculum in
                NavigationLink(destination:
                    CurriculumDetailsView(curriculum: curriculum, onStartActivity: self.onStartActivity)
                        .logEventScreenView(
                            screenName: "curriculum_details",
                            context: .splitView,
                            parameters: [
                                "lk_curriculum_id": "\(curriculum.name)-\(curriculum.id)",
                            ]
                        )
                ) {
                    GroupboxItem(CurationItemModel(id: curriculum.id, contentType: .curriculum))
                }
                .simultaneousGesture(TapGesture().onEnded {
                    AnalyticsManager.logEventSelectContent(
                        type: .curriculum,
                        id: curriculum.id,
                        name: curriculum.name,
                        origin: .personalLibrary
                    )
                })
            }
        }
        .padding()
    }

    // MARK: Internal

    let curriculums: [Curriculum]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    private let columns = [
        GridItem(.adaptive(minimum: 280), spacing: 20),
    ]
}

#Preview {
    NavigationStack {
        CurriculumGridView(
            curriculums: ContentKit.allCurriculums,
            onStartActivity: { _ in
                print("Activity Selected")
            }
        )
    }
}
