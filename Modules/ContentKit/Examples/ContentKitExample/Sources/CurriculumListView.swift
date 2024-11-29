// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import MarkdownUI
import SwiftUI

// MARK: - CurriculumListView

struct CurriculumListView: View {
    let activities: [Curriculum] = ContentKit.allCurriculums

    var body: some View {
        List {
            ForEach(self.activities) { curriculum in
                NavigationLink(destination:
                    CurriculumDetailsView(curriculum: curriculum)
                ) {
                    Image(uiImage: curriculum.details.iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    Text(curriculum.details.title)
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
        .navigationTitle("Curriculums")
    }
}

#Preview {
    NavigationStack {
        CurriculumListView()
    }
}
