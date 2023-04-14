// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TemplateSelector: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Environment(\.dismiss) var dismiss

    @State var selected: Int = 0
    @State private var columns = Array(repeating: GridItem(), count: 2)

    var body: some View {
        ScrollView(showsIndicators: true) {
            LazyVGrid(columns: columns) {
                ForEach(configuration.templatesPreviews.indices, id: \.self) { item in
                    Button(
                        action: {
                            selected = item
                            switch configuration.templatesScope {
                                // Here, assign to configuration.allUsedTemplates following model in there
                                case .activity: print("activity scope in temp. selector")
                                case .group: print("group scope in temp. selector")
                                case .step: print("step scope in temp. selector")
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                dismiss()
                            }
                        },
                        label: {
                            previewButton(configuration.templatesPreviews[item])
                        }
                    )
                    .buttonStyle(
                        TemplatePreview_ButtonStyle(
                            isSelected: selected == item,
                            name: configuration.templatesPreviews[item])
                    )
                    .padding(20)
                }
            }
            .padding(20)
        }
        .navigationTitle("Sélectionner un template de réponses")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.accentColor, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func previewButton(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
