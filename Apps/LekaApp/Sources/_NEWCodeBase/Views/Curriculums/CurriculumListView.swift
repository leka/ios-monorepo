// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

struct CurriculumListView: View {
    let activities: [Curriculum] = ContentKit.listSampleCurriculums() ?? []

    var body: some View {
        ForEach(self.activities) { curriculum in
            NavigationLink(destination: CurriculumDetailsView(curriculum: curriculum)) {
                Image(uiImage: curriculum.details.iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                Text(curriculum.details.title)
            }
        }
    }
}

#Preview {
    CurriculumListView()
}
