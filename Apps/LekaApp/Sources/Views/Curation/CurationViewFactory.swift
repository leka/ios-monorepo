// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - ComponentItemType

enum ComponentItemType: String {
    case carouselItem
    case cardItem
    case contentGridItem
    case columnListItem
    case tileItem
}

// MARK: - CurationViewFactory

public struct CurationViewFactory: View {
    // MARK: Lifecycle

    public init(section: CategoryCuration.Section) {
        self.section = section
        switch section.componentType {
            case .carousel:
                self.layoutType = .horizontalGrid
                self.componentItemType = .carouselItem
            case .horizontalColumnList:
                self.layoutType = .horizontalGrid
                self.componentItemType = .columnListItem
            case .horizontalCardList:
                self.layoutType = .horizontalGrid
                self.componentItemType = .cardItem
            case .verticalContentList:
                self.layoutType = .verticalGrid
                self.componentItemType = .contentGridItem
            case .verticalTileGrid:
                self.layoutType = .verticalGrid
                self.componentItemType = .tileItem
            case .horizontalTileGrid:
                self.layoutType = .horizontalGrid
                self.componentItemType = .tileItem
        }
    }

    // MARK: Public

    public var body: some View {
        switch self.layoutType {
            case .horizontalGrid:
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: self.rows, spacing: 15) {
                        let items = self.section.items.prefix(self.componentItemType == .columnListItem ? 15 : 8)
                        ForEach(items) { item in
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
                LazyVGrid(columns: self.columns, spacing: 10) {
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
        case horizontalGrid
        case verticalGrid
    }

    let section: CategoryCuration.Section
    let layoutType: LayoutType
    let componentItemType: ComponentItemType

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private var rows: [GridItem] {
        Array(repeating: GridItem(spacing: 15), count: self.section.componentType == .horizontalColumnList ? 3 : 1)
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(spacing: 10), count: self.section.items.count % 3 == 0 || self.section.items.count > 4 ? 3 : 2)
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
        switch self.componentItemType {
            case .carouselItem:
                CarouselItem(curation)
            case .cardItem:
                CardItem(curation)
            case .contentGridItem:
                ContentGridItem(curation)
            case .columnListItem:
                ColumnListItem(curation)
            case .tileItem:
                TileItem(curation)
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
        CurationViewFactory(section: ContentKit.allCurations.first!.value.sections[0])
        CurationViewFactory(section: ContentKit.allCurations.first!.value.sections[1])
        CurationViewFactory(section: ContentKit.allCurations.first!.value.sections[2])
        CurationViewFactory(section: ContentKit.allCurations.first!.value.sections[3])
    }
    .padding()
}
