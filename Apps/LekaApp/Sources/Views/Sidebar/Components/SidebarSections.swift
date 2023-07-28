// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarSections: View {

    @EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        section(content: sidebar.educContentList)
            .padding(.horizontal)
            .foregroundColor(.accentColor)
    }

    func sectionItem(_ item: SectionLabel) -> some View {
        Button {
            sidebar.currentView = item.destination
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

    func section(content: ListModel) -> some View {
        Section {
            ForEach(content.sections.indices, id: \.self) { item in
                NavigationLink(destination: sidebar.allSidebarDestinationViews) {
                    sectionItem(content.sections[item])
                }
                .isDetailLink(true)
            }
        } header: {
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title)
                    .font(metrics.semi20)
                    .padding(.vertical, 10)
                Divider()
            }
        }
    }
}
