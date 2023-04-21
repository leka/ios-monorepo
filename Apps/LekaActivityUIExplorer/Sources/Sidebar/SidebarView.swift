// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var isExpanded: Bool = false
    @State private var selectedTemplate: Int = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                logoLeka
                    .padding(.bottom, 50)
                    .padding(.top, 10)

                LazyVGrid(columns: [GridItem()]) {
                    ForEach(configuration.allTemplatesPreviews.indices, id: \.self) { item in
                        Button(
                            action: {
                                selectedTemplate = item
                                navigator.sidebarVisibility = .detailOnly
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    setupTest(withTemplate: item)
                                }
                            },
                            label: {
                                previewButton(configuration.allTemplatesPreviews[item])
                            }
                        )
                        .buttonStyle(
                            TemplatePreview_ButtonStyle(
                                isSelected: selectedTemplate == item,
                                name: configuration.allTemplatesPreviews[item])
                        )
                        .padding(20)
                    }
                }
                .padding(20)
            }
            .frame(maxWidth: .infinity)
            .font(defaults.semi17)
            .foregroundColor(.white)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(LekaActivityUIExplorerAsset.Colors.lekaLightGray.swiftUIColor)

    }

    private func setupTest(withTemplate: Int) {
        setupExplorerVariations(forTemplate: withTemplate)
        gameEngine.bufferActivity = ExplorerActivity(withTemplate: withTemplate).makeActivity()
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
            configuration.preferred4AnswersLayout = .spaced
        } else if forTemplate == 6 {
            configuration.preferred4AnswersLayout = .inline
        } else {
            configuration.preferred3AnswersLayout = .basic
            configuration.preferred4AnswersLayout = .spaced
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
