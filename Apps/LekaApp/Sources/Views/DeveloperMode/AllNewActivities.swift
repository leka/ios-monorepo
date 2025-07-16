// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - AllNewActivities

var allNewActivitiescancellables = Set<AnyCancellable>()

// MARK: - AllNewActivities

struct AllNewActivities: View {
    let activities: [NewActivity] = ContentKit.allNewActivities.values.map { $0 }

    @State private var activityDidEnd: Bool = false
    @State var isActivityPresented: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ForEach(self.activities, id: \.id) { activity in
                    Button {
                        self.isActivityPresented = true
                        self.navigation.setCurrentNewActivity(activity)
                    } label: {
                        Text(activity.name)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: self.$isActivityPresented) {
            NavigationStack {
                if let activity = self.navigation.currentNewActivity, let coordinator = self.navigation.currentNewCoordinator {
                    NewActivityView(activity: activity, coordinator: coordinator)
                        .navigationTitle("Mixed exercises")
                        .navigationBarTitleDisplayMode(.inline)
                        .onAppear {
                            coordinator.activityEvent
                                .receive(on: DispatchQueue.main)
                                .sink { event in
                                    switch event {
                                        case .didStart:
                                            log.debug("Publisher - Activity did start")
                                        case .didEnd:
                                            log.debug("Publisher - Activity did end")
                                            self.activityDidEnd = true
                                    }
                                }
                                .store(in: &allNewActivitiescancellables)
                        }
                        .fullScreenCover(isPresented: self.$activityDidEnd) {
                            self.endOfActivityScoreView
                        }
                } else {
                    Text("Activity not recognized")
                }
            }
        }
    }

    // MARK: Private

    private var navigation: Navigation = .shared

    @ViewBuilder
    private var endOfActivityScoreView: some View {
        // TODO: (@ladislas, @HPezz) Add success condition & percentage when implemented
        if true {
            SuccessView(percentage: 90)
        } else {
            FailureView(percentage: 30)
        }
    }
}

#Preview {
    NavigationStack {
        AllNewActivities()
    }
}
