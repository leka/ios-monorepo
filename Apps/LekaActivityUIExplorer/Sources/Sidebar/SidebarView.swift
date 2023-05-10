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
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(TouchToSelectPreviews.allCases, id: \.rawValue) { item in
                            Button(
                                action: {
                                    selectedTemplate = item.rawValue
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item.rawValue, type: item.content.type)
                                    }
                                },
                                label: {
                                    previewButton(item.content.preview)
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item.rawValue,
                                    name: item.content.preview)
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

                DisclosureGroup {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(ListenThenTouchToSelectPreviews.allCases, id: \.rawValue) { item in
                            Button(
                                action: {
                                    selectedTemplate = item.rawValue
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item.rawValue, type: item.content.type)
                                    }
                                },
                                label: {
                                    ZStack(alignment: .topTrailing) {
                                        previewButton(item.content.preview)
                                        Image(systemName: "speaker.wave.2.circle")
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
                                    isSelected: selectedTemplate == item.rawValue,
                                    name: item.content.preview)
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

                DisclosureGroup {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(ColorQuestPreviews.allCases, id: \.rawValue) { item in
                            Button(
                                action: {
                                    selectedTemplate = item.rawValue
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item.rawValue, type: item.content.type)
                                    }
                                },
                                label: {
                                    previewButton(item.content.preview)
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item.rawValue,
                                    name: item.content.preview)
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

                DisclosureGroup {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(MiscPreviews.allCases, id: \.rawValue) { item in
                            Button(
                                action: {
                                    selectedTemplate = item.rawValue
                                    navigator.sidebarVisibility = .detailOnly
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        setupTest(withTemplate: item.rawValue, type: item.content.type)
                                    }
                                },
                                label: {
                                    previewButton(item.content.preview)
                                }
                            )
                            .buttonStyle(
                                TemplatePreview_ButtonStyle(
                                    isSelected: selectedTemplate == item.rawValue,
                                    name: item.content.preview)
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

    private func setupTest(withTemplate: Int, type: ActivityType) {
        configuration.setupExplorerVariations(forTemplate: withTemplate)
        gameEngine.bufferActivity = ExplorerActivity(withTemplate: withTemplate, type: type).makeActivity()
        gameEngine.setupGame()
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
