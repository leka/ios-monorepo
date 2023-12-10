// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityListView: View {
    // MARK: Internal

    @EnvironmentObject var curriculumVM: CurriculumViewModel
    @EnvironmentObject var activityVM: ActivityViewModel
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    // Data modeled for Search Feature
    @State var searchQuery = ""

    var searchResults: [String] {
        guard self.searchQuery.isEmpty else {
            return self.curriculumVM.activityFilesCompleteList.filter {
                self.activityVM.getActivity($0).title.localized().localizedCaseInsensitiveContains(self.searchQuery)
                //				|| $0.texts[1].localizedCaseInsensitiveContains(searchQuery)
                //				|| $0.texts[3].localizedCaseInsensitiveContains(searchQuery)
            }
            // filters are titles & keywords (added later), and in curriculums => subtitle, short
            // later add played/unplayed, last played, sound only etc...
        }
        return self.curriculumVM.activityFilesCompleteList
    }

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()
            self.completeActivityList
        }
        .animation(.easeOut(duration: 0.4), value: self.navigationVM.showInfo())
        .searchable(
            text: self.$searchQuery,
            placement: .toolbar,
            prompt: Text("Media, personnages, ...")
        )
        .onAppear { self.navigationVM.sidebarVisibility = .all }
        .navigationDestination(
            for: String.self,
            destination: { _ in
                SelectedActivityInstructionsView()
            }
        )
    }

    // MARK: Private

    private var completeActivityList: some View {
        ScrollViewReader { proxy in
            List(self.searchResults.enumerated().map { $0 }, id: \.element) { index, item in
                HStack {
                    Spacer()
                    Button {
                        self.activityVM.currentActivity = self.activityVM.getActivity(item)
                        self.activityVM.selectedActivityID = UUID(uuidString: self.activityVM.getActivity(item).id)
                        self.navigationVM.pathsFromHome.append("instructions")
                    } label: {
                        ActivityListCell(
                            activity: self.activityVM.getActivity(item),
                            icon: item,
                            rank: index + 1,
                            selected: self.activityVM.selectedActivityID == UUID(uuidString: self.activityVM.getActivity(item).id)
                        )
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        0
                    }
                    .frame(maxWidth: 600)
                    .buttonStyle(NoFeedback_ButtonStyle())
                    .contentShape(Rectangle())
                    Spacer()
                }
                .id(UUID(uuidString: self.activityVM.getActivity(item).id))
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, 20)
            .background(.white, in: Rectangle())
            .edgesIgnoringSafeArea(.bottom)
            .animation(.default, value: self.searchQuery)
            .safeAreaInset(edge: .top) {
                InfoTileManager()
            }
            .onAppear {
                guard self.activityVM.selectedActivityID != nil else {
                    return
                }
                withAnimation { proxy.scrollTo(self.activityVM.selectedActivityID, anchor: .center) }
            }
        }
    }
}
