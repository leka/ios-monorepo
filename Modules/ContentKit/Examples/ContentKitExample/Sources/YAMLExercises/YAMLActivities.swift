// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - YAMLActivities

var YAMLActivitiesCancellables = Set<AnyCancellable>()

// MARK: - YAMLActivities

struct YAMLActivities: View {
    // MARK: Internal

    @State var activityDidEnd: Bool = false

    var body: some View {
        NavigationStack {
            if let activity = self.navigation.currentActivity, let coordinator = self.navigation.currentCoordinator {
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
                            .store(in: &YAMLActivitiesCancellables)
                    }
                    .fullScreenCover(isPresented: self.$activityDidEnd) {
                        self.endOfActivityScoreView
                    }
            } else {
                Text("Activity not recognized")
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
    YAMLActivities()
}
