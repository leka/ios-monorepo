// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TilesFeedbackEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @ObservedObject var templateDefaults: XylophoneDefaults = Misc.xylophone

    var body: some View {
        Section {
            Group {
                rotationAngleSlider
                scaleSlider
            }
        } header: {
            Text("Feedback des tuiles")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        } footer: {
            HStack {
                Spacer()
                Button(
                    action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            templateDefaults.customTilesRotationFeedback = templateDefaults.defaultTilesRotationFeedback
                            templateDefaults.customTilesScaleFeedback = templateDefaults.defaultTilesScaleFeedback
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

    private var rotationAngleSlider: some View {
        LabeledContent {
            Slider(
                value: $templateDefaults.customTilesRotationFeedback,
                in: -10...10,
                step: 1,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(templateDefaults.customTilesRotationFeedback))")
                }
            )
            .frame(maxWidth: 260)
            .tint(LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor)
        } label: {
            Text("Rotation")
                .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.leading, 20)
        }
    }

    private var scaleSlider: some View {
        LabeledContent {
            Slider(
                value: $templateDefaults.customTilesScaleFeedback,
                in: 0.5...1.2,
                step: 0.01,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text(String(format: "%.2f", templateDefaults.customTilesScaleFeedback))
                }
            )
            .frame(maxWidth: 260)
            .tint(LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor)
        } label: {
            Text("Échelle")
                .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.leading, 20)
        }
    }
}
