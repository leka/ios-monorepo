// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

struct SampleActivityListView: View {
    // MARK: Internal

    let activities: [Activity] = ContentKit.listSampleActivities() ?? []

    var body: some View {
        List {
            ForEach(self.activities) { activity in
                NavigationLink(destination:
                    ActivityDetailsView(activity: activity)
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    self.navigation.currentActivity = activity
                                } label: {
                                    Image(systemName: "play.circle")
                                    Text("Start activity")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.lkGreen)
                            }
                        }
                ) {
                    Image(uiImage: activity.details.iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())

                    Text(activity.details.title)
                }
            }
        }
        .navigationTitle("Sample Activities")
    }

    // MARK: Private

    private var navigation = Navigation.shared
}

#Preview {
    NavigationStack {
        SampleActivityListView()
    }
}
