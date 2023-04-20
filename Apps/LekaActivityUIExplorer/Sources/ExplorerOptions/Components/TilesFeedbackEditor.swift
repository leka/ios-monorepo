//
//  TilesFeedbackEditor.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 20/4/23.
//

import SwiftUI

struct TilesFeedbackEditor: View {
    
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GLT_Defaults

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
                            defaults.xylophoneTilesRotationFeedback = -1
                            defaults.xylophoneTilesScaleFeedback = 0.98
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
                value: $defaults.xylophoneTilesRotationFeedback,
                in: -10...10,
                step: 1,
                label: {},
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text("\(Int(defaults.xylophoneTilesRotationFeedback))")
                }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
        } label: {
            Text("Rotation")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }
    
    private var scaleSlider: some View {
        LabeledContent {
            Slider(
                value: $defaults.xylophoneTilesScaleFeedback,
                in: 0.5...1.2,
                step: 0.01,
                label: {},
                minimumValueLabel: {
                    Text("•")
                },
                maximumValueLabel: {
                    Text(String(format: "%.2f", defaults.xylophoneTilesScaleFeedback))
                }
            )
            .frame(maxWidth: 260)
            .tint(Color("lekaSkyBlue"))
        } label: {
            Text("Échelle")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }
}
