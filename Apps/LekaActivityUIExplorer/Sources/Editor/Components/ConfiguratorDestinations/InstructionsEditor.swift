//
//  InstructionsEditor.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 2/4/23.
//

import MarkdownUI
import SwiftUI

struct InstructionsEditor: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Environment(\.dismiss) var dismiss

    @Binding var language: Languages

    @State private var instructions: String = ""

    var body: some View {
        VStack(spacing: 0) {
            if configuration.disableEditor {
                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        Image(systemName: "ellipses.bubble.fill")
                        Text(
                            "Cette activité (Sample) n'est pas éditable. Il est seulement possible de consulter sa configuration."
                        )
                    }
                    .font(defaults.reg13)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.accentColor)
                    .padding(.vertical, 20)
                    Divider()
                }
            } else {
                EmptyView()
            }

            HStack(spacing: 0) {
                TextEditor(text: $instructions)
                    .padding(40)
                    .disabled(configuration.disableEditor)
                Divider().ignoresSafeArea()
                InstructionView(text: $instructions)
                    .background(Color("lekaLightGray"))
            }
            .navigationTitle("Consigne de l'activité")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { saveButton }
            }
            .onAppear {
                instructions = {
                    switch language {
                        case .french: return gameEngine.bufferActivity.instructions.frFR!
                        case .english: return gameEngine.bufferActivity.instructions.enUS!
                    }
                }()
            }
        }
    }

    private var saveButton: some View {
        Button(
            action: {
                switch language {
                    case .french: gameEngine.bufferActivity.instructions.frFR = instructions
                    case .english: gameEngine.bufferActivity.instructions.enUS = instructions
                }
                dismiss()
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle")
                    Text("Enregistrer")
                }
            })
    }
}
