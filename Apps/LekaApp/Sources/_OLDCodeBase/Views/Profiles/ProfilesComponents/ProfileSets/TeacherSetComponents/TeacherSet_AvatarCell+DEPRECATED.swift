// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct TeacherSet_AvatarCellDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var viewRouter: ViewRouterDeprecated
    @EnvironmentObject var metrics: UIMetrics

    let teacher: TeacherDeprecated

    var body: some View {
        Button {
            withAnimation {
                self.company.selectedProfiles[.teacher] = self.teacher.id
            }
            if self.settings.companyIsLoggingIn {
                self.company.assignCurrentProfiles()
                self.settings.companyIsLoggingIn = false
                self.viewRouter.currentPage = .home
            }
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    // Selection Indicator
                    self.selectionIndicator(id: self.teacher.id)
                    // Avatar
                    Circle()
                        .fill(
                            DesignKitAsset.Colors.lekaLightGray.swiftUIColor,
                            strokeBorder: .white,
                            lineWidth: 3
                        )
                        .overlay(content: {
                            Image(self.teacher.avatar, bundle: Bundle(for: DesignKitResources.self))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .padding(2)
                        })
                }
                .frame(height: 108)
                .padding(10)

                Text(self.teacher.name)
                    .font(.body)
                    .allowsTightening(true)
                    .lineLimit(2)
                    .padding(.horizontal, 14)
                    .foregroundColor(
                        self.company.profileIsCurrent(.teacher, id: self.teacher.id)
                            ? Color.white : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                    )
                    .padding(2)
                    .frame(minWidth: 108)
                    .background(content: {
                        RoundedRectangle(cornerRadius: self.metrics.btnRadius)
                            .stroke(.white, lineWidth: 2)
                    })
                    .background(
                        self.company.profileIsCurrent(.teacher, id: self.teacher.id)
                            ? DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor
                            : DesignKitAsset.Colors.lekaLightGray.swiftUIColor,
                        in: RoundedRectangle(cornerRadius: self.metrics.btnRadius)
                    )
            }
        }
        .buttonStyle(NoFeedback_ButtonStyle())
    }

    // MARK: Private

    private func selectionIndicator(id: UUID) -> some View {
        // TODO(@ladislas): review logic in the future
        let lineWidth: CGFloat = {
            guard self.company.selectedProfiles[.teacher] == id else {
                guard self.company.profileIsCurrent(.teacher, id: id) else {
                    return 0
                }
                return 10
            }
            return 10
        }()

        let dash: [CGFloat] = {
            guard self.company.profileIsCurrent(.teacher, id: id) else {
                return [10, 4]
            }
            return [10, 0]
        }()

        return Circle()
            .stroke(
                DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .butt,
                    lineJoin: .round,
                    dash: dash
                )
            )
    }
}
