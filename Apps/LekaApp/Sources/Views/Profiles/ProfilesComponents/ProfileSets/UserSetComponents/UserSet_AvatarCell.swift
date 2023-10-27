// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct UserSet_AvatarCell: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

    let user: User

    var body: some View {
        Button {
            withAnimation {
                company.selectedProfiles[.user] = user.id
            }
            // Next context is within the userSelector right before launching a game
            if !navigationVM.showProfileEditor {
                company.assignCurrentProfiles()
                navigationVM.pathToGame.append(PathsToGame.game)
            }
        } label: {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    // Selection Indicator
                    selectionIndicator(id: user.id)
                    // Avatar
                    Circle()
                        .fill(
                            DesignKitAsset.Colors.lekaLightGray.swiftUIColor,
                            strokeBorder: .white,
                            lineWidth: 3
                        )
                        .overlay(content: {
                            Image(user.avatar, bundle: Bundle(for: DesignKitResources.self))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .padding(2)
                        })
                    // Reinforcer Badge
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)
                        Image(uiImage: company.getReinforcerFor(index: user.reinforcer))
                            .resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                            .padding(2)
                            .background(DesignKitAsset.Colors.lekaLightGray.swiftUIColor, in: Circle())

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
                    .foregroundColor(
                        company.profileIsCurrent(.user, id: user.id)
                            ? Color.white : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                    )
                    .padding(2)
                    .frame(minWidth: 108)
                    .background(content: {
                        RoundedRectangle(cornerRadius: metrics.btnRadius)
                            .stroke(.white, lineWidth: 2)
                    })
                    .background(
                        company.profileIsCurrent(.user, id: user.id)
                            ? DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor
                            : DesignKitAsset.Colors.lekaLightGray.swiftUIColor,
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
                DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .butt,
                    lineJoin: .round,
                    dash: dash))
        Circle()
            .stroke(
                DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor,
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
