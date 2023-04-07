//
//  SizeEditor.swift
//  LekaActivityGenerator
//
//  Created by Mathieu Jeannot on 10/4/23.
//  Copyright © 2023 leka.io. All rights reserved.
//

import SwiftUI

struct SizeEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GLT_Defaults

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
                            defaults.playGridBtnSize = 200
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
                label: {},
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
}
