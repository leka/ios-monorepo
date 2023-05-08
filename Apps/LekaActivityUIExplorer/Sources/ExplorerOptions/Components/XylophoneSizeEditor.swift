// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct XylophoneSizeEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @ObservedObject var templateDefaults: XylophoneDefaults = Misc.xylophone

    var body: some View {
        Section {
            tileWidthSlider
        } header: {
            Text("Taille des réponses")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        } footer: {
            HStack {
                Spacer()
                Button(
                    action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            templateDefaults.customTileWidth = templateDefaults.defaultTileWidth
                        }
                    },
                    label: {
                        HStack(spacing: 6) {
                            Text("Valeur par défaut")
                            Image(systemName: "arrow.counterclockwise.circle")
                        }
                        .font(defaults.reg15)
                        .foregroundColor(.accentColor)
                    })
            }
        }
    }

    private var tileWidthSlider: some View {
        LabeledContent {
            Slider(
                value: $templateDefaults.customTileWidth,
                in: 80...300,
                step: 1,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(templateDefaults.customTileWidth))")
                }
            )
            .frame(maxWidth: 260)
            .tint(LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor)
        } label: {
            Text("Largeur")
                .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.leading, 20)
        }
    }
}
