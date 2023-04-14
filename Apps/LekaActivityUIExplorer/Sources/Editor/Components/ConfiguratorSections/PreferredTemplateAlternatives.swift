// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct PreferredTemplateAlternatives: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    var body: some View {
        Section {
            Group {
                templatePicker3
                templatePicker4
            }
        } header: {
            Text("Templates alternatifs")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }

    private var templatePicker3: some View {
        NavigationLink(destination: AlternativeTemplateSelector(count: 3)) {
            Text("Choisir un template pour les étapes ayant 3 réponses")
                .foregroundColor(Color("lekaSkyBlue"))
        }
        .padding(.leading, 30)
        .frame(minHeight: 35)
    }

    private var templatePicker4: some View {
        NavigationLink(destination: AlternativeTemplateSelector(count: 4)) {
            Text("Choisir un template pour les étapes ayant 4 réponses")
                .foregroundColor(Color("lekaSkyBlue"))
        }
        .padding(.leading, 30)
        .frame(minHeight: 35)
    }
}
