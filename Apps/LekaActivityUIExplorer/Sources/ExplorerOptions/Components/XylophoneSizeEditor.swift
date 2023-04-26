//
//  XylophoneSizeEditor.swift
//  LekaActivityUIExplorer
//
//  Created by Mathieu Jeannot on 26/4/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct XylophoneSizeEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @ObservedObject var templateDefaults: XylophoneTemplatesDefaults

    // Store Default values

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
                            // TODO: (@Macteuts) Come up with a solution to revert to contextual defaults
                            templateDefaults.tileWidth = 180
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
                value: $templateDefaults.tileWidth,
                in: 80...300,
                step: 1,
                label: {
                    // Unnecessary
                },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(templateDefaults.tileWidth))")
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
