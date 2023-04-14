// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct InstructionsEditorTrigger: View {

    @Binding var language: Languages

    var body: some View {
        Section {
            NavigationLink(destination: InstructionsEditor(language: $language)) {
                Text("Ouvrir l'éditeur de consigne")
                    .foregroundColor(Color("lekaSkyBlue"))
            }
            .frame(minHeight: 50)
            .padding(.leading, 30)
        } header: {
            Text("Consigne")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }
}
