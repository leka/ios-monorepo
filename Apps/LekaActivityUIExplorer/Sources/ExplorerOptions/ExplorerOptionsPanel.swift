// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ExplorerOptionsPanel: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    // Templates defaults
    @ObservedObject var templateDefaults: DefaultsTemplate
    @EnvironmentObject var xylophoneDefaults: XylophoneTemplatesDefaults

    @Binding var closePanel: Bool

    var body: some View {
        HStack {
            Spacer()
            ZStack {
                LekaActivityUIExplorerAsset.Colors.lekaLightGray.swiftUIColor.ignoresSafeArea()

                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(height: 50)
                        .overlay(
                            ZStack {
                                Text("Édition de l'aperçu")
                                    .font(defaults.semi17)
                                    .foregroundColor(.white)
                                closeOptionsButton
                            }
                        )
                        .padding(.bottom, 14)

                    Form {
                        Group {
                            if gameEngine.currentActivity.activityType != "xylophone" {
                                NumberOfGroups()
                                SizeEditor(templateDefaults: templateDefaults)
                            } else {
                                XylophoneSizeEditor(templateDefaults: xylophoneDefaults)
                            }
                            if gameEngine.currentActivity.activityType == "xylophone" {
                                XylophoneSpacingEditor(templateDefaults: xylophoneDefaults)
                            } else if gameEngine.allAnswers.count > 1 {
                                SpacingEditor(templateDefaults: templateDefaults)
                            }
                            if gameEngine.currentActivity.activityType == "xylophone" {
                                TilesFeedbackEditor()
                            }
                        }
                        .padding(.top, 6)
                    }
                    .padding(.horizontal, 10)
                    .formStyle(.grouped)
                    .foregroundColor(.accentColor)
                    .font(defaults.reg17)
                }
            }
            .frame(maxWidth: 500, maxHeight: 800)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 0)
            .padding(20)
        }
    }

    private var closeOptionsButton: some View {
        HStack {
            Spacer()
            Button(
                action: {
                    withAnimation(.easeIn(duration: 0.4)) {
                        closePanel.toggle()
                    }
                },
                label: {
                    Image(systemName: "multiply")
                        .font(defaults.semi20)
                        .foregroundColor(.white)
                }
            )
            .padding(.horizontal, 20)
        }
    }
}
