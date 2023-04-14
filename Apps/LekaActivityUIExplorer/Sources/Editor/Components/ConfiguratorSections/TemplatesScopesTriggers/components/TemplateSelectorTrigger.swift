// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TemplateSelectorTrigger: View {

    //	@EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    var body: some View {
        NavigationLink(destination: TemplateSelector()) {
            Text("Ouvrir le sélecteur de Templates")
                .foregroundColor(Color("lekaSkyBlue"))
        }
        .padding(.leading, 30)
        .frame(minHeight: 35)
    }
}
