// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var touchToSelectIsExpanded: Bool = false
    @State private var listenThenTouchIsExpanded: Bool = false
    @State private var colorQuestIsExpanded: Bool = false
    @State private var miscIsExpanded: Bool = false
    @State private var selectedTemplate: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                logoLeka
                    .padding(.bottom, 50)
                    .padding(.top, 10)

                DisclosureGroup(isExpanded: $touchToSelectIsExpanded) {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(configuration.touchToSelectPreviews.indices, id: \.self) { item in
                            Button(
                                action: {
                                    selectedTemplate = item
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item, type: "touch_to_select")
                                    }
                                },
                                label: {
                                    previewButton(configuration.touchToSelectPreviews[item])
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item,
                                    name: configuration.touchToSelectPreviews[item])
                            )
                            .padding(20)
                        }
                    }
                    .padding(20)
                } label: {
                    Text("touch_to_select")
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 20)

                DisclosureGroup(isExpanded: $listenThenTouchIsExpanded) {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(configuration.listenThenTouchToSelectPreviews.indices, id: \.self) { item in
                            Button(
                                action: {
                                    selectedTemplate = item
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item, type: "listen_then_touch_to_select")
                                    }
                                },
                                label: {
                                    ZStack(alignment: .topTrailing) {
                                        previewButton(configuration.listenThenTouchToSelectPreviews[item])
                                        Image(systemName: "play.circle")
                                            .font(defaults.reg18)
                                            .foregroundColor(
                                                LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor
                                            )
                                            .padding(4)
                                    }
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item,
                                    name: configuration.listenThenTouchToSelectPreviews[item])
                            )
                            .padding(20)
                        }
                    }
                    .padding(20)
                } label: {
                    Text("listen_then_touch_to_select")
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 20)

                DisclosureGroup(isExpanded: $colorQuestIsExpanded) {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(configuration.colorQuestPreviews.indices, id: \.self) { item in
                            Button(
                                action: {
                                    selectedTemplate = item
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item, type: "color_quest")
                                    }
                                },
                                label: {
                                    ZStack(alignment: .topTrailing) {
                                        previewButton(configuration.colorQuestPreviews[item])
                                        Image(systemName: "play.circle")
                                            .font(defaults.reg18)
                                            .foregroundColor(
                                                LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor
                                            )
                                            .padding(4)
                                    }
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item,
                                    name: configuration.colorQuestPreviews[item])
                            )
                            .padding(20)
                        }
                    }
                    .padding(20)
                } label: {
                    Text("color_quest")
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
                }
                .padding(.horizontal, 20)

                DisclosureGroup(isExpanded: $miscIsExpanded) {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(configuration.miscPreviews.indices, id: \.self) { item in
                            Button(
                                action: {
                                    selectedTemplate = item
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item, type: "xylophone")
                                    }
                                },
                                label: {
                                    previewButton(configuration.miscPreviews[item])
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item,
                                    name: configuration.miscPreviews[item])
                            )
                            .padding(20)
                        }
                    }
                    .padding(20)
                } label: {
                    Text("xylophone")
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 8))
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

    private func setupTest(withTemplate: Int, type: String) {
        setupExplorerVariations(forTemplate: withTemplate)
        gameEngine.bufferActivity = ExplorerActivity(withTemplate: withTemplate, type: type).makeActivity()
        gameEngine.setupGame()
    }

    private func setupExplorerVariations(forTemplate: Int) {
        if forTemplate == 2 {
            configuration.preferred3AnswersLayout = .basic
        } else if forTemplate == 3 {
            configuration.preferred3AnswersLayout = .inline
        } else if forTemplate == 4 {
            configuration.preferred4AnswersLayout = .basic
        } else if forTemplate == 5 {
            configuration.preferred4AnswersLayout = .inline
        }
    }

    private var logoLeka: some View {
        LekaActivityUIExplorerAsset.Images.lekaLogo.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.top, 40)
    }

    private func previewButton(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
