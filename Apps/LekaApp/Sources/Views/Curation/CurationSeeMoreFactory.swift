// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import SwiftUI

// MARK: - CurationSeeMoreFactory

public struct CurationSeeMoreFactory: View {
    // MARK: Lifecycle

    public init(section: CategoryCuration.Section) {
        self.section = section
        switch section.componentType {
            case .carousel:
                self.componentItemType = .carouselItem
            case .horizontalColumnList:
                self.componentItemType = .columnListItem
            case .horizontalCardList:
                self.componentItemType = .cardItem
            case .verticalContentList:
                self.componentItemType = .contentGridItem
            case .verticalTileGrid,
                 .horizontalTileGrid:
                self.componentItemType = .tileItem
        }
    }

    // MARK: Public

    public var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: self.columns) {
                ForEach(self.section.items) { item in
                    NavigationLink(destination:
                        AnyView(self.curationDestination(item.curation))
                    ) {
                        AnyView(self.curationLabel(item.curation))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: Internal

    let section: CategoryCuration.Section
    let componentItemType: ComponentItemType

    // MARK: Private

    @ObservedObject private var navigation: Navigation = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared

    private var columns: [GridItem] {
        Array(repeating: GridItem(), count: 3)
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
            case .tileItem:
                TileItem(curation)
            default:
                ContentGridItem(curation)
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
        CurationSeeMoreFactory(section: ContentKit.allCurations.first!.value.sections[0])
        CurationSeeMoreFactory(section: ContentKit.allCurations.first!.value.sections[1])
        CurationSeeMoreFactory(section: ContentKit.allCurations.first!.value.sections[2])
    }
    .padding()
}
