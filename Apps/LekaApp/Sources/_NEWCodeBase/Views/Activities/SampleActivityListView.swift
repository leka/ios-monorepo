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
                                    self.isCarereceiverPickerPresented = true
                                    self.selectedActivity = activity
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
        .sheet(isPresented: self.$isCarereceiverPickerPresented) {
            NavigationStack {
                CarereceiverPicker {
                    self.isCarereceiverPickerPresented = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.navigation.currentActivity = self.selectedActivity
                    }
                }
            }
        }
    }

    // MARK: Private

    private var navigation = Navigation.shared
    @State private var selectedActivity: Activity?
    @State private var isCarereceiverPickerPresented = false
}

#Preview {
    NavigationStack {
        SampleActivityListView()
    }
}
