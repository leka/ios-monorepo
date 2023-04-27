// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SizeEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @ObservedObject var templateDefaults: DefaultsTemplate

    // Store Default values

    var body: some View {
        Section {
            sizeSlider
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
                            templateDefaults.playGridBtnSize = templateDefaults.defaultSize
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

    private var sizeSlider: some View {
        LabeledContent {
            Slider(
                value: $templateDefaults.playGridBtnSize,
                in: 100...300,
                step: 10,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(templateDefaults.playGridBtnSize))")
                }
            )
            .frame(maxWidth: 260)
            .tint(LekaActivityUIExplorerAsset.Colors.lekaSkyBlue.swiftUIColor)
        } label: {
            Text("Taille")
                .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
                .padding(.leading, 20)
        }
    }
}
