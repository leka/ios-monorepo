// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct UserSet_AvatarCell: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter  // Delete this
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var sidebar: SidebarViewModel

    let user: User

    var body: some View {
        Button {
            withAnimation {
                company.selectedProfiles[.user] = user.id
            }
            // Next context is within the userSelector right before launching a game
            if !sidebar.showProfileEditor {
                company.assignCurrentProfiles()
                if viewRouter.currentPage == .curriculumDetail {
                    viewRouter.pathFromCurriculum.append(.game)  // Delete this & the condition
                } else {
                    sidebar.pathToGame.append(PathsToGame.game)
                }
            }
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    // Selection Indicator
                    selectionIndicator(id: user.id)
                    // Avatar
                    Circle()
                        .fill(
                            Color("lekaLightGray"),
                            strokeBorder: .white,
                            lineWidth: 3
                        )
                        .overlay(content: {
                            Image(user.avatar)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .padding(2)
                        })
                    // Reinforcer Badge
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(Color("lekaLightGray"))
                        Image("reinforcer-\(user.reinforcer)")
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .padding(2)
                            .background(Color("lekaLightGray"), in: Circle())

                        Circle()
                            .stroke(.white, lineWidth: 3)
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                    .offset(x: 6, y: -6)
                }
                .frame(height: 108)
                .padding(10)

                Text(user.name)
                    .font(metrics.reg15)
                    .allowsTightening(true)
                    .lineLimit(2)
                    .padding(.horizontal, 14)
                    .foregroundColor(company.profileIsCurrent(.user, id: user.id) ? Color.white : Color("darkGray"))
                    .padding(2)
                    .frame(minWidth: 108)
                    .background(content: {
                        RoundedRectangle(cornerRadius: metrics.btnRadius)
                            .stroke(.white, lineWidth: 2)
                    })
                    .background(
                        company.profileIsCurrent(.user, id: user.id) ? Color("lekaSkyBlue") : Color("lekaLightGray"),
                        in: RoundedRectangle(cornerRadius: metrics.btnRadius))
            }
        }
        .buttonStyle(NoFeedback_ButtonStyle())
    }

    @ViewBuilder
    private func selectionIndicator(id: UUID) -> some View {
        // TODO(@ladislas): review logic in the future
        let lineWidth: CGFloat = {
            guard company.selectedProfiles[.user] == id else {
                guard company.profileIsCurrent(.user, id: id) else {
                    return 0
                }
                return 10
            }
            return 10
        }()

        let dash: [CGFloat] = {
            guard company.profileIsCurrent(.user, id: id) else {
                return [10, 4]
            }
            return [10, 0]
        }()

        Circle()
            .stroke(
                Color("lekaSkyBlue"),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .butt,
                    lineJoin: .round,
                    dash: dash))
        Circle()
            .stroke(
                Color("lekaSkyBlue"),
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .butt,
                    lineJoin: .round,
                    dash: dash)
            )
            .frame(maxWidth: 40, maxHeight: 40)
            .offset(x: 6, y: -6)
    }
}
