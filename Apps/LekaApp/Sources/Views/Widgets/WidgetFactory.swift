// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - WidgetFactory

public struct WidgetFactory: View {
    // MARK: Lifecycle

    public init(section: CategoryCuration.Section) {
        self.section = section
        switch section.componentType {
            case .carousel:
                self.layoutType = .horizontalScroll
                self.widgetType = .contentCard
            case .column:
                self.layoutType = .horizontalScrollList
                self.widgetType = .listItem
            case .groupbox:
                self.layoutType = .horizontalScroll
                self.widgetType = .groupbox
            case .grid:
                self.layoutType = .verticalGrid
                self.widgetType = .verticalItem
            case .verticalButton:
                self.layoutType = .verticalGrid
                self.widgetType = .curationButton
            case .horizontalButton:
                self.layoutType = .horizontalScroll
                self.widgetType = .curationButton
        }
    }

    // MARK: Public

    public var body: some View {
        switch self.layoutType {
            case .horizontalScrollList:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30) {
                        ForEach(self.section.items.chunked(into: 3), id: \.self) { chunk in
                            VStack {
                                ForEach(chunk) { item in
                                    NavigationLink(destination:
                                        AnyView(self.curationDestination(item.curation))
                                    ) {
                                        AnyView(self.curationLabel(item.curation))
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                }
                .padding()
            case .horizontalScroll:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(self.section.items) { item in
                            NavigationLink(destination:
                                AnyView(self.curationDestination(item.curation))
                            ) {
                                AnyView(self.curationLabel(item.curation))
                            }
                        }
                    }
                }
                .padding()
            case .verticalGrid:
                LazyVGrid(columns: self.columns) {
                    ForEach(self.section.items) { item in
                        NavigationLink(destination:
                            AnyView(self.curationDestination(item.curation))
                        ) {
                            AnyView(self.curationLabel(item.curation))
                        }
                    }
                }
                .padding()
        }
    }

    // MARK: Internal

    enum LayoutType: String {
        case horizontalScrollList
        case horizontalScroll
        case verticalGrid
    }

    enum WidgetType: String {
        case groupbox
        case verticalItem
        case listItem
        case contentCard
        case curationButton
    }

    let section: CategoryCuration.Section
    let layoutType: LayoutType
    let widgetType: WidgetType

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private var columns: [GridItem] {
        Array(repeating: GridItem(), count: self.section.items.count % 3 == 0 || self.section.items.count > 4 ? 3 : 2)
    }

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

    private func curationLabel(_ curation: CurationItemModel) -> any View {
        switch self.widgetType {
            case .groupbox:
                GroupboxItem(curation)
            case .verticalItem:
                VerticalItem(curation)
            case .listItem:
                ListItem(curation)
            case .contentCard:
                ContentCard(curation)
            case .curationButton:
                CurationButton(curation)
        }
    }

    private func curationDestination(_ curation: CurationItemModel) -> any View {
        switch curation.contentType {
            case .curriculum:
                guard let curriculum = Curriculum(id: curation.id) else {
                    return Text("Curriculum \(curation.id) not found")
                }
                return CurriculumDetailsView(curriculum: curriculum, onStartActivity: self.onStartActivity)
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
                return CurationView(curation: curation)
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
