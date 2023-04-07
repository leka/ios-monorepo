//
//  ScopeTriggerGroup.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 4/4/23.
//

import SwiftUI

struct ScopeTriggerGroup: View {

    @EnvironmentObject var configuration: GLT_Configurations
    @EnvironmentObject var gameEngine: GameEngine

    @State private var isOn: Bool = false
    @State private var scope: TemplateSelectionScope = .group
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
                if isOn { TemplateSelectorTrigger() }
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
                guard !configuration.allUsedTemplates.isEmpty else {
                    return
                }
                // all steps in group use the same
                index = configuration.allUsedTemplates[configuration.currentlyEditedGroupIndex][0]
            }
        } header: {
            Text("Template")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }
}
