// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarSections: View {

    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        section(content: navigationVM.educContentList)
            .padding(.horizontal)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    func sectionItem(_ item: SectionLabel) -> some View {
        Button {
            navigationVM.currentView = item.destination
            // emty navigation Stacks
            navigationVM.pathsFromHome = .init()
            // reset user's choice to work without robot
            robotVM.userChoseToPlayWithoutRobot = false
        } label: {
            HStack(spacing: 10) {
                Image(systemName: item.icon)
                    .font(metrics.light24)
                    .frame(maxWidth: 30, maxHeight: 30)
                    .padding(.leading, 10)

                Text(item.label)
                    .font(metrics.reg17)

                Spacer()
            }
            .foregroundColor(
                navigationVM.currentView.rawValue == item.destination.rawValue
                    ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
            )
            .frame(height: 44)
            .background(
                navigationVM.currentView.rawValue == item.destination.rawValue
                    ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .clear,
                in: RoundedRectangle(cornerRadius: metrics.btnRadius, style: .continuous)
            )
            .contentShape(Rectangle())
        }
    }

    func section(content: ListModel) -> some View {
        Section {
            ForEach(content.sections.indices, id: \.self) { item in
                sectionItem(content.sections[item])
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
