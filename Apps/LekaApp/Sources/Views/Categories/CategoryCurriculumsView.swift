// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CategoryCurriculumsView

struct CategoryCurriculumsView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            ScrollView(showsIndicators: true) {
                HStack(alignment: .center, spacing: 30) {
                    Image(systemName: "graduationcap")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(self.styleManager.accentColor!)

                    VStack(alignment: .leading) {
                        Text(self.category.details.subtitle)
                            .font(.title2)

                        Text(self.category.details.description)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)

                Spacer()

                VStack(alignment: .leading, spacing: 30) {
                    ForEach(self.category.sections) { section in
                        Section {
                            VStack(alignment: .leading, spacing: 5) {
                                VStack(alignment: .leading) {
                                    HStack(alignment: .firstTextBaseline) {
                                        HStack(alignment: .center) {
                                            Text(section.details.title)
                                                .font(.title2)
                                                .foregroundStyle(self.styleManager.accentColor!)
                                            Divider()
                                        }
                                        Text(section.details.subtitle)
                                            .font(.headline)
                                    }

                                    Text(section.details.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal)
                                .padding(.horizontal)

                                CurriculumGridView(curriculums: section.curriculums, onActivitySelected: { activity in
                                    if self.authManagerViewModel.userAuthenticationState == .loggedIn {
                                        self.navigation.sheetContent = .carereceiverPicker(activity: activity, story: nil)
                                    } else {
                                        self.navigation.currentActivity = activity
                                        self.navigation.fullScreenCoverContent = .activityView(carereceivers: [])
                                    }
                                })

                                Divider()
                                    .padding(.horizontal)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(self.category.details.title)
    }

    // MARK: Private

    private let category: CategoryCurriculums = .shared

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var authManagerViewModel: AuthManagerViewModel = .shared
    @ObservedObject private var navigation: Navigation = .shared
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        CategoryCurriculumsView()
    }
}
