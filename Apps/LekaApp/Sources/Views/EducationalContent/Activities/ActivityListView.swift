// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityListView: View {

    @EnvironmentObject var curriculumVM: CurriculumViewModel
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    // Data modeled for Search Feature
    @State var searchQuery = ""
    var searchResults: [String] {
        guard searchQuery.isEmpty else {
            return curriculumVM.activityFilesCompleteList.filter {
                activityVM.getActivity($0).title.localized().localizedCaseInsensitiveContains(searchQuery)
                //				|| $0.texts[1].localizedCaseInsensitiveContains(searchQuery)
                //				|| $0.texts[3].localizedCaseInsensitiveContains(searchQuery)
            }
            // filters are titles & keywords (added later), and in curriculums => subtitle, short
            // later add played/unplayed, last played, sound only etc...
        }
        return curriculumVM.activityFilesCompleteList
    }

    var body: some View {
        ZStack {
            Color("lekaLightBlue").ignoresSafeArea()
            completeActivityList
        }
        .animation(.easeOut(duration: 0.4), value: sidebar.showInfo())
        .searchable(
            text: $searchQuery,
            placement: .toolbar,
            prompt: Text("Media, personnages, ...")
        )
        .onAppear { sidebar.sidebarVisibility = .all }
    }

    private var completeActivityList: some View {
        ScrollViewReader { proxy in
            List(searchResults.enumerated().map({ $0 }), id: \.element) { index, item in
                HStack {
                    Spacer()
                    Button {
                        activityVM.currentActivity = activityVM.getActivity(item)
                        activityVM.selectedActivityID = UUID(uuidString: activityVM.getActivity(item).id)
                        sidebar.pathsFromHome.append("instructions")
                    } label: {
                        ActivityListCell(
                            activity: activityVM.getActivity(item),
                            icon: item,
                            rank: index + 1,
                            selected: activityVM.selectedActivityID == UUID(uuidString: activityVM.getActivity(item).id)
                        )
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                    .frame(maxWidth: 600)
                    .buttonStyle(NoFeedback_ButtonStyle())
                    .contentShape(Rectangle())
                    Spacer()
                }
                .id(UUID(uuidString: activityVM.getActivity(item).id))
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 20)
            .background(.white, in: Rectangle())
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default, value: searchQuery)
            .safeAreaInset(edge: .top) {
                InfoTileManager()
            }
            .onAppear {
                guard activityVM.selectedActivityID != nil else {
                    return
                }
                withAnimation { proxy.scrollTo(activityVM.selectedActivityID, anchor: .center) }
            }
        }
    }
}
