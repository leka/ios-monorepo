// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SpacingEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @ObservedObject var templateDefaults: BaseDefaults

    var body: some View {
        Section {
            Group {
                horizontalSpacingSlider
                if gameEngine.allAnswers.count >= 3 && hasVerticalSpacing() {
                    verticalSpacingSlider
                }
            }
        } header: {
            Text("Espacement des réponses")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        } footer: {
            HStack {
                Spacer()
                Button(
                    action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            templateDefaults.customHorizontalSpacing = templateDefaults.defaultHorizontalSpacing
                            templateDefaults.customVerticalSpacing = templateDefaults.defaultVerticalSpacing
                        }
                    },
                    label: {
                        HStack(spacing: 6) {
                            Text("Valeurs par défaut")
                            Image(systemName: "arrow.counterclockwise.circle")
                        }
                        .font(defaults.reg15)
                        .foregroundColor(.accentColor)
                    })
            }
        }
    }

    private func hasVerticalSpacing() -> Bool {
        guard
            gameEngine.interface == .touch3Inline
                || gameEngine.interface == .touch4Inline
                || gameEngine.interface == .soundTouch3Inline
                || gameEngine.interface == .soundTouch4Inline
        else {
            return true
        }
        return false
    }

    private var horizontalSpacingSlider: some View {
        LabeledContent {
            Slider(
                value: $templateDefaults.customHorizontalSpacing,
                in: 10...200,
                step: 10,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(templateDefaults.customHorizontalSpacing))")
                }
            )
            .frame(maxWidth: 260)
            .tint(LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor)
        } label: {
            Text("Horizontal")
                .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.leading, 20)
        }
    }

    private var verticalSpacingSlider: some View {
        LabeledContent {
            Slider(
                value: $templateDefaults.customVerticalSpacing,
                in: 10...200,
                step: 10,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(templateDefaults.customVerticalSpacing))")
                }
            )
            .frame(maxWidth: 260)
            .tint(LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor)
        } label: {
            Text("Vertical")
                .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.leading, 20)
        }
    }
}
