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
    static let sortedActivities: [NewActivity] = ContentKit.allNewActivities.values.map { $0 }.sorted { $0.name < $1.name }
    static let groupedActivities = Dictionary(grouping: sortedActivities) { String($0.name.prefix { $0.isLetter }) }.values.map(Array.init)

    @State private var activityDidEnd: Bool = false
    @State var isActivityPresented: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(AllNewActivities.groupedActivities, id: \.self) { activities in
                    Section {
                        let randomColor = Color.random()
                        VStack(alignment: .leading, spacing: 5) {
                            Text(activities[0].name.prefix { $0.isLetter })
                                .font(.title2)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(activities, id: \.id) { activity in
                                        Button {
                                            self.isActivityPresented = true
                                            self.navigation.setCurrentNewActivity(activity)
                                        } label: {
                                            ActivityButtonLabel(text: String(activity.name.split(separator: "_").last!), color: randomColor)
                                        }
                                        .padding()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: self.$isActivityPresented) {
            NavigationStack {
                if let activity = self.navigation.currentNewActivity, let coordinator = self.navigation.currentNewCoordinator {
                    NewActivityView(activity: activity, coordinator: coordinator)
                        .navigationTitle(activity.name)
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

    private struct ActivityButtonLabel: View {
        let text: String
        let color: Color

        var body: some View {
            Text(self.text)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(width: 150, height: 100)
                .padding()
                .background(Capsule().fill(self.color).shadow(radius: 1))
        }
    }
}

#Preview {
    NavigationStack {
        AllNewActivities()
    }
}
