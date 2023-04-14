// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarSections: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    // Delete when FollowUp is Ready
    private func simulateChange() {
        // simulate some change of profile for now
        sidebar.successValues.shuffle()
        company.willBeDeletedFakeFollowUpNumberOfCells = Int.random(in: 0...10)
    }

    var body: some View {
        VStack(spacing: 20) {
            ForEach(NavSections.allCases, id: \.rawValue) { group in
                if group == .educ {
                    section(isExpanded: $sidebar.educContentIsExpanded, content: sidebar.educContentList)
                } else if group == .followUp {
                    section(isExpanded: $sidebar.followUpIsExpanded, content: sidebar.followUpList)
                }
            }
        }
        .padding(.horizontal)
        .tint(.accentColor)
    }

    func sectionItem(_ item: SectionLabel) -> some View {
        Button {
            sidebar.has3Columns = item.has3Columns
            sidebar.currentView = item.destination
            if sidebar.has3Columns {
                // Sort profiles alpha+current-first, then preselect
                if sidebar.currentView == .teachers {
                    company.sortProfiles(.teacher)
                    sidebar.currentlySelectedTeacherProfile = company.profilesInUse[.teacher] ?? UUID()
                } else if sidebar.currentView == .users {
                    company.sortProfiles(.user)
                    sidebar.currentlySelectedUserProfile = company.profilesInUse[.user] ?? UUID()
                }

                simulateChange()
            }
        } label: {
            HStack(spacing: 10) {
                Image(item.icon)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 30, maxHeight: 30)
                    .padding(.leading, 10)

                Text(item.label)
                    .font(metrics.reg17)

                Spacer()
            }
            .foregroundColor(sidebar.currentView.rawValue == item.destination.rawValue ? .white : .accentColor)
            .frame(height: 44)
            .background(
                sidebar.currentView.rawValue == item.destination.rawValue ? Color.accentColor : .clear,
                in: RoundedRectangle(cornerRadius: metrics.btnRadius, style: .continuous)
            )
            .contentShape(Rectangle())
        }
    }

    func section(isExpanded: Binding<Bool>, content: ListModel) -> some View {
        DisclosureGroup(isExpanded: isExpanded) {
            ForEach(content.sections.indices, id: \.self) { item in
                NavigationLink(destination: sidebar.allSidebarDestinationViews) {
                    sectionItem(content.sections[item])
                }
                .isDetailLink(true)
            }
        } label: {
            Text(content.title)
                .font(metrics.semi20)
                .padding(.vertical, 10)
        }
    }
}
