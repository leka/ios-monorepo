// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var selectedTemplate: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                logoLeka
                    .padding(.bottom, 50)
                    .padding(.top, 10)

                DisclosureGroup {
                    TouchToSelectNavigationGroup(selected: $selectedTemplate) { setupTest() }
                } label: {
                    disclosureGroupLabel("touch_to_select")
                }
                .padding(.horizontal, 20)

                DisclosureGroup {
                    ListenThenTouchToSelectNavigationGroup(selected: $selectedTemplate) { setupTest() }
                } label: {
                    disclosureGroupLabel("listen_then_touch_to_select")
                }
                .padding(.horizontal, 20)

                DisclosureGroup {
                    ColorQuestNavigationGroup(selected: $selectedTemplate) { setupTest() }
                } label: {
                    disclosureGroupLabel("color_quest")
                }
                .padding(.horizontal, 20)

                DisclosureGroup {
                    MiscNavigationGroup(selected: $selectedTemplate) { setupTest() }
                } label: {
                    disclosureGroupLabel("xylophone")
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .font(defaults.semi17)
            .foregroundColor(.white)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(LekaActivityUIExplorerAsset.Colors.lekaLightGray.swiftUIColor)

    }

    private func setupTest() {
        configuration.setupExplorerVariations(forTemplate: selectedTemplate)
        gameEngine.bufferActivity = ExplorerActivity(
            withTemplate: selectedTemplate,
            type: configuration.currentActivityType
        )
        .makeActivity()
        gameEngine.setupGame()
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
