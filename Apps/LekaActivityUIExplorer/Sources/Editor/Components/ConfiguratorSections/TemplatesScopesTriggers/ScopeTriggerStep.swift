//
//  ScopeTriggerStep.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 5/4/23.
//

import SwiftUI

struct ScopeTriggerStep: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine

    @State private var isOn: Bool = false
    @State private var scope: TemplateSelectionScope = .step
    @State private var index: Int = 0

    var body: some View {
        Section {
            Group {
                LabeledContent {
                    Toggle("", isOn: $isOn)
                        .toggleStyle(SwitchToggleStyle(tint: Color("lekaSkyBlue")))
                        .labelsHidden()
                } label: {
                    Text("Chaque groupe utilise un template distinct")
                        .foregroundColor(Color("lekaDarkGray"))
                        .padding(.leading, 30)
                }
                if isOn {
                    TemplateSelectorTrigger()
                }
            }
            .onChange(of: isOn) { newValue in
                if newValue {
                    configuration.templatesScope = scope
                    configuration.navigateToTemplateSelector.toggle()
                }  // Make method to switch between scopes
            }
            //			.onChange(of: gameEngine.bufferActivity, perform: { _ in
            //				uniqueTemplate = scope == configuration.templatesScope
            //			})
            .onAppear {
                isOn = scope == configuration.templatesScope
                guard !configuration.allUsedTemplates[configuration.currentlyEditedGroupIndex].isEmpty else {
                    return
                }
                // all steps in group use the same
                index =
                    configuration.allUsedTemplates[configuration.currentlyEditedGroupIndex][
                        configuration.currentlyEditedStepIndex]
            }
        } header: {
            Text("Template")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }
}
