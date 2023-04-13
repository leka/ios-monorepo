//
//  SpacingEditor.swift
//  LekaActivityGenerator
//
//  Created by Mathieu Jeannot on 10/4/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct SpacingEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Section {
            Group {
                horizontalSpacingSlider
                verticalSpacingSlider
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
                            defaults.horizontalCellSpacing = 32
                            defaults.verticalCellSpacing = 32
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

    private var horizontalSpacingSlider: some View {
        LabeledContent {
            Slider(
                value: $defaults.horizontalCellSpacing,
                in: 10...200,
                step: 10,
                label: { /* no label */  },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(defaults.horizontalCellSpacing))")
                }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
        } label: {
            Text("Horizontal")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }

    private var verticalSpacingSlider: some View {
        LabeledContent {
            Slider(
                value: $defaults.verticalCellSpacing,
                in: 10...200,
                step: 10,
                label: { /* no label */  },
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(defaults.verticalCellSpacing))")
                }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
        } label: {
            Text("Vertical")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }
}
