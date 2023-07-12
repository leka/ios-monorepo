// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                logoLeka
                    .padding(.bottom, 50)
                    .padding(.top, 10)

                DisclosureGroup {
                    TouchToSelectNavigationGroup()
                } label: {
                    disclosureGroupLabel("touch_to_select")
                }

                DisclosureGroup {
                    ListenThenTouchToSelectNavigationGroup()
                } label: {
                    disclosureGroupLabel("listen_then_touch_to_select")
                }

                DisclosureGroup {
                    ColorQuestNavigationGroup()
                } label: {
                    disclosureGroupLabel("color_quest")
                }

                DisclosureGroup {
                    DragAndDropNavigationGroup()
                } label: {
                    disclosureGroupLabel("drag_and_drop")
                }

                DisclosureGroup {
                    MiscNavigationGroup()
                } label: {
                    disclosureGroupLabel("xylophone")
                }

                DisclosureGroup {
                    RemoteNavigationGroup()
                } label: {
                    disclosureGroupLabel("remote")
                }

                DisclosureGroup {
                    DanceFreezeNavigationGroup()
                } label: {
                    disclosureGroupLabel("dance_freeze")
                }

                DisclosureGroup {
                    HideAndSeekNavigationGroup()
                } label: {
                    disclosureGroupLabel("hide_and_seek")
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .font(defaults.semi17)
            .foregroundColor(.white)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(LekaActivityUIExplorerAsset.Colors.lekaLightGray.swiftUIColor)

    }

    private var logoLeka: some View {
        LekaActivityUIExplorerAsset.Images.lekaLogo.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.top, 40)
    }

    private func disclosureGroupLabel(_ text: String) -> some View {
        Text(text)
            .frame(height: 32)
            .frame(maxWidth: .infinity)
            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
    }
}
