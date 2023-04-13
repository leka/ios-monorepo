//
//  LayoutTemplatePicker.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 2/4/23.
//

import SwiftUI

struct ScopeTriggerActivity: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine

    @State private var isOn: Bool = false
    @State private var scope: TemplateSelectionScope = .activity
    @State private var index: Int = 0

    var body: some View {
        Section {
            Group {
                LabeledContent {
                    Toggle("", isOn: $isOn)
                        .toggleStyle(SwitchToggleStyle(tint: Color("lekaSkyBlue")))
                        .labelsHidden()
                } label: {
                    Text("L'activité utilise un template unique")
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
            .onAppear {
                isOn = scope == configuration.templatesScope
                // They all use the same
                index = configuration.allUsedTemplates[0][0]
            }
        } header: {
            Text("Template")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }
}
