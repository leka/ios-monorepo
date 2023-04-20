// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SizeEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Section {
            if gameEngine.currentActivity.activityType != "xylophone" {
                sizeSlider
            } else {
                tileWidthSlider
            }
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
                            if gameEngine.currentActivity.activityType != "xylophone" {
                                defaults.playGridBtnSize = 200
                            } else {
                                defaults.xylophoneTileWidth = 180
                            }
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
                value: $defaults.playGridBtnSize,
                in: 100...300,
                step: 10,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(defaults.playGridBtnSize))")
                }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
        } label: {
            Text("Taille")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }

    private var tileWidthSlider: some View {
        LabeledContent {
            Slider(
                value: $defaults.xylophoneTileWidth,
                in: 80...300,
                step: 1,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(defaults.xylophoneTileWidth))")
                }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
        } label: {
            Text("Largeur")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }
}
