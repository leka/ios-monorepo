//
//  StepConfigurator.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 1/4/23.
//

import SwiftUI

struct GroupEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Environment(\.dismiss) var dismiss

    @State private var selectedLanguage: Languages = .french
    @State private var uniqueGroupTemplate: Bool = true

    var body: some View {
        ZStack {
            Color("lekaLightGray").ignoresSafeArea()

            VStack(spacing: 0) {
                topBanner

                Form {
                    Group {
                        languagePicker
                            .listRowBackground(Color("lekaLightGray"))

                        ScopeTriggerGroup()
                            .disabled(configuration.disableEditor)
                            .disabled(configuration.originalSteps.count < 1)

                        ForEach(
                            $gameEngine.bufferActivity.stepSequence[configuration.currentlyEditedGroupIndex]
                                .enumerated().map({ $0 }), id: \.offset
                        ) { index, $step in
                            StepEditor(rank: .constant(index + 1), step: $step, language: $selectedLanguage)
                        }
                    }
                    .padding(.top, 6)
                    Spacer()
                        .frame(height: 2)
                        .listRowBackground(Color("lekaLightGray"))
                }
                .padding(.horizontal, 20)
                .formStyle(.grouped)
                .foregroundColor(.accentColor)
                .font(defaults.reg17)
            }
        }
        .navigationTitle("Éditeur d'étapes")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.accentColor, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            if !configuration.disableEditor {
                ToolbarItem(placement: .navigationBarTrailing) { saveButton }
            }
        }
    }

    private var languagePicker: some View {
        HStack {
            Spacer()
            Picker("", selection: $selectedLanguage) {
                Text("Français").tag(Languages.french)
                Text("Anglais").tag(Languages.english)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 150 * CGFloat(Languages.allCases.count))
            Spacer()
        }
    }

    private var saveButton: some View {
        Button(
            action: {
                // save the steps
                dismiss()
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle")
                    Text("Enregistrer")
                }
            })
    }

    @ViewBuilder
    private var topBanner: some View {
        if configuration.disableEditor {
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: "ellipses.bubble.fill")
                    Text(
                        "Cette activité (Sample) n'est pas éditable. Il est seulement possible de consulter sa configuration."
                    )
                }
                .font(defaults.reg13)
                .multilineTextAlignment(.leading)
                .foregroundColor(.accentColor)

                Divider()
            }
            .padding(.top, 20)
        } else {
            VStack(spacing: 20) {
                HStack(spacing: 10) {
                    Image(systemName: "ellipses.bubble.fill")
                    switch configuration.templatesScope {
                        case .activity:
                            Text("Cette activité est configurée pour utiliser un template unique.")
                        case .group:
                            Text("Cette activité est configurée pour utiliser un template par groupe.")
                        case .step:
                            Text("Cette activité est configurée pour utiliser un template par étape.")
                    }
                }
                .font(defaults.reg13)
                .multilineTextAlignment(.leading)
                .foregroundColor(.accentColor)

                Divider()
            }
            .padding(.top, 20)
        }
    }
}
