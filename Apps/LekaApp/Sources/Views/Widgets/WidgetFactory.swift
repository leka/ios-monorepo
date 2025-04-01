// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - WidgetFactory

public struct WidgetFactory: View {
    // MARK: Public

    public var body: some View {
        switch self.section.widgetType {
            case .groupbox:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.section.items) { item in
                            NavigationLink(destination:
                                AnyView(self.curationDestination(item.curation))
                            ) {
                                GroupboxItem(item.curation)
                            }
                        }
                    }
                }
            case .gridlist:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(self.section.items.chunked(into: 3), id: \.self) { chunk in
                            VStack {
                                ForEach(chunk) { item in
                                    NavigationLink(destination:
                                        AnyView(self.curationDestination(item.curation))
                                    ) {
                                        ListItem(item.curation)
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                }
            case .contentCard:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.section.items) { item in
                            NavigationLink(destination:
                                AnyView(self.curationDestination(item.curation))
                            ) {
                                ContentCard(item.curation)
                            }
                        }
                    }
                }
            case .curationButton:
                if self.section.items.count > 3 {
                    HStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            ForEach(self.section.items) { item in
                                NavigationLink(destination:
                                    AnyView(self.curationDestination(item.curation))
                                ) {
                                    CurationButton(item.curation)
                                }
                            }
                        }
                    }
                } else {
                    HStack {
                        ForEach(self.section.items) { item in
                            NavigationLink(destination:
                                AnyView(self.curationDestination(item.curation))
                            ) {
                                CurationButton(item.curation)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
        }
    }

    // MARK: Internal

    let section: CategoryCuration.Section

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private func onStartActivity(_ activity: Activity) {
        if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
            self.navigation.sheetContent = .carereceiverPicker(activity: activity, story: nil)
        } else {
            self.navigation.currentActivity = activity
            self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
        }
    }

    private func onStartStory(_ story: Story) {
        if self.authManagerViewModel.userAuthenticationState == .loggedIn, !self.navigation.demoMode {
            self.navigation.sheetContent = .carereceiverPicker(activity: nil, story: story)
        } else {
            self.navigation.currentStory = story
            self.navigation.fullScreenCoverContent = .storyView(carereceivers: [])
        }
    }

    private func curationDestination(_ curation: CurationItemModel) -> any View {
        switch curation.contentType {
            case .curriculum:
                guard let curriculum = Curriculum(id: curation.id) else {
                    return Text("Curriculum \(curation.id) not found")
                }
                return CurriculumDetailsView(curriculum: curriculum, onActivitySelected: self.onStartActivity)
            case .activity:
                guard let activity = Activity(id: curation.id) else {
                    return Text("Activity \(curation.id) not found")
                }
                return ActivityDetailsView(activity: activity, onStartActivity: self.onStartActivity)
            case .story:
                guard let story = Story(id: curation.id) else {
                    return Text("Story \(curation.id) not found")
                }
                return StoryDetailsView(story: story, onStartStory: self.onStartStory)
            case .curation:
                guard let curation = CategoryCuration(id: curation.id) else {
                    return Text("Curation \(curation.id) not found")
                }
                return CurationSandbox(curation: curation)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WidgetFactory(section: ContentKit.allCurations[0].sections[0])
        WidgetFactory(section: ContentKit.allCurations[0].sections[1])
        WidgetFactory(section: ContentKit.allCurations[0].sections[2])
    }
    .padding()
}
