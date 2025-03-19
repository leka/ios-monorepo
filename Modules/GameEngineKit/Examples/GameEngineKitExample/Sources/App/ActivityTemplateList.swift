// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

struct ActivityTemplateList: View {
    let activities: [Activity] = ContentKit.allTemplateActivities.sorted { $0.name < $1.name }

    var body: some View {
        List {
//            ForEach(self.activities) { activity in
//                let viewModel = NewActivityViewModel(activity: activity)
//
//                NavigationLink(destination: NewActivityView(viewModel: viewModel)) {
//                    Image(uiImage: activity.details.iconImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 70, height: 70)
//
//                    VStack(alignment: .leading) {
//                        Text("\(activity.details.title)")
//                            .font(.headline)
//                        Text("\(activity.details.subtitle ?? "")")
//                            .font(.subheadline)
//                    }
//                    .padding()
//                }
//            }
        }
    }
}

#Preview {
    NavigationStack {
        ActivityTemplateList()
    }
}
