//
//  AlternativeTemplateSelector.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import SwiftUI

struct AlternativeTemplateSelector: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Environment(\.dismiss) var dismiss

    var count: Int
    @State var selected: Int = 0
    @State private var columns = Array(repeating: GridItem(), count: 2)
    @State private var previewsArray: [String] = []

    var body: some View {
        ScrollView(showsIndicators: true) {
            LazyVGrid(columns: columns) {
                ForEach(previewsArray.indices, id: \.self) { item in
                    Button(action: {
                        selected = item
                        assignAlternatives()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                    }) {
                        if count == 3 {
                            previewButton(configuration.templatesPreviewsAlternatives3[item])
                        } else {
                            previewButton(configuration.templatesPreviewsAlternatives4[item])
                        }
                    }
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
        .onAppear {
            preselectTemplate()
        }
    }

    private func preselectTemplate() {
        if count == 3 {
            previewsArray = configuration.templatesPreviewsAlternatives3
            switch configuration.preferred3AnswersLayout {
                case .inline: selected = 1
                default: selected = 0
            }
        } else {
            previewsArray = configuration.templatesPreviewsAlternatives4
            switch configuration.preferred4AnswersLayout {
                case .inline: selected = 2
                case .basic: selected = 1
                default: selected = 0
            }
        }
    }

    private func assignAlternatives() {
        if count == 3 {
            configuration.templatesPreviews[2] = configuration.templatesPreviewsAlternatives3[selected]
            configuration.preferred3AnswersLayout = {
                guard selected == 0 else {
                    return .inline
                }
                return .basic
            }()
        } else {
            configuration.templatesPreviews[3] = configuration.templatesPreviewsAlternatives4[selected]
            configuration.preferred4AnswersLayout = {
                if selected == 0 {
                    return .spaced
                } else if selected == 1 {
                    return .basic
                } else {
                    return .inline
                }
            }()
        }
    }

    private func previewButton(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
