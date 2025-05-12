// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import SwiftUI

// MARK: - CurriculumHorizontalListView

public struct CurriculumHorizontalListView: View {
    // MARK: Lifecycle

    public init(curriculums: [Curriculum]? = nil, onStartActivity: ((Activity) -> Void)?) {
        self.curriculums = curriculums ?? []
        self.onStartActivity = onStartActivity
    }

    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline) {
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
                        CardItem(CurationItemModel(id: curriculum.id, contentType: .curriculum))
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        AnalyticsManager.logEventSelectContent(
                            type: .curriculum,
                            id: curriculum.id,
                            name: curriculum.name,
                            origin: .generalLibrary
                        )
                    })
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let curriculums: [Curriculum]
    let onStartActivity: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    private let rows = [GridItem()]
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack {
                Section {
                    CurriculumHorizontalListView(
                        curriculums: Array(ContentKit.allCurriculums.values),
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: Array(ContentKit.allCurriculums.values),
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: Array(ContentKit.allCurriculums.values),
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: Array(ContentKit.allCurriculums.values),
                        onStartActivity: { _ in
                            print("Activity Selected")
                        }
                    )
                }
            }
        }
    }
}
