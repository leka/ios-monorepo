// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarSections: View {
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var robotVM: RobotViewModel
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        self.section(content: self.navigationVM.educContentList)
            .padding(.horizontal)
    }

    func sectionItem(_ item: SectionLabel) -> some View {
        Button {
            self.navigationVM.currentView = item.destination
            // emty navigation Stacks
            self.navigationVM.pathsFromHome = .init()
            // reset user's choice to work without robot
            self.robotVM.userChoseToPlayWithoutRobot = false
        } label: {
            HStack {
                Label(item.label, systemImage: item.icon)
                    .font(.body)
                Spacer()
            }
            .padding(10)
            .foregroundColor(
                self.navigationVM.currentView.rawValue == item.destination.rawValue
                    ? .white : DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
            )
            .frame(height: 44)
            .background(
                self.navigationVM.currentView.rawValue == item.destination.rawValue
                    ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : .clear,
                in: RoundedRectangle(cornerRadius: self.metrics.btnRadius, style: .continuous)
            )
            .contentShape(Rectangle())
        }
    }

    func section(content: ListModel) -> some View {
        Section {
            ForEach(content.sections.indices, id: \.self) { item in
                self.sectionItem(content.sections[item])
            }
        } header: {
            VStack(alignment: .leading, spacing: 6) {
                Text(content.title)
                    .font(.title2)
                    .padding(.vertical, 10)
                Divider()
            }
        }
    }
}
