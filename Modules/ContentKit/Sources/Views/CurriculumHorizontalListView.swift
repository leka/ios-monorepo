// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurriculumHorizontalListView

public struct CurriculumHorizontalListView: View {
    // MARK: Lifecycle

    public init(curriculums: [Curriculum]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.curriculums = curriculums ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline) {
                ForEach(self.curriculums) { curriculum in
                    NavigationLink(destination:
                        CurriculumDetailsView(curriculum: curriculum, onActivitySelected: self.onActivitySelected)
                            .logEventScreenView(
                                screenName: "curriculum_details",
                                context: .splitView,
                                parameters: [
                                    "lk_curriculum_id": "\(curriculum.name)-\(curriculum.id)",
                                ]
                            )
                    ) {
                        CurriculumGroupboxView(curriculum: curriculum)
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
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    private let columns = Array(repeating: GridItem(), count: 3)
    private let rows = [GridItem()]
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack {
                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }
            }
        }
    }
}
