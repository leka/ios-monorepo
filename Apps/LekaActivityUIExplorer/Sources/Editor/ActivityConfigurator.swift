// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityConfigurator: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Environment(\.dismiss) var dismiss

    @State private var selectedLanguage: Languages = .french
    @State private var triggerSoonAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("lekaLightGray").ignoresSafeArea()

                if configuration.editorIsEmpty {
                    Text("Sélectionner un modèle pour commencer")
                } else {
                    VStack(spacing: 0) {
                        testingDemoMessage

                        Form {
                            Group {
                                languagePicker
                                    .listRowBackground(Color("lekaLightGray"))
                                ActivityTitleAndShort(language: $selectedLanguage)
                                    .disabled(configuration.disableEditor)
                                InstructionsEditorTrigger(language: $selectedLanguage)
                                ScopeTriggerActivity()
                                    .disabled(configuration.disableEditor)
                                PreferredTemplateAlternatives()
                                AnswersSize()
                                ActivityParameters()
                                    .disabled(configuration.disableEditor)
                                SequenceConfiguration()
                                LekaLogo()
                            }
                            .padding(.top, 6)
                        }
                        .padding(.horizontal, 20)
                        .formStyle(.grouped)
                        .foregroundColor(.accentColor)
                        .font(defaults.reg17)
                    }
                }
            }
            // when Step scope will be ready
            //		.navigationDestination(isPresented: $configuration.navigateToTemplateSelector, destination: {
            //			TemplateSelector(selected: <#T##Binding<Int>#>)
            //		})
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) { navigationTitle }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    testButton
                    editionMenu
                }
            }
            .alert("Importer", isPresented: $triggerSoonAlert) {
                Button("Coming Soon...", action: { /* not implemented yet */  })
            } message: {
                Text("Importer un fichier yaml (.yml)")
            }
        }
    }

    @ViewBuilder
    private var testingDemoMessage: some View {
        if configuration.disableEditor {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    Image(systemName: "ellipses.bubble.fill")
                    Text(
                        "Cette activité (Démo) n'est pas éditable. Il est seulement possible de consulter sa configuration."
                    )
                }
                HStack(spacing: 10) {
                    Image(systemName: "lightbulb.fill")
                    Text("Sélectionner un modèle pour réactiver l'éditeur.")
                }
                .padding(.bottom, 10)
                Divider()
            }
            .font(defaults.reg13)
            .multilineTextAlignment(.leading)
            .foregroundColor(.accentColor)
            .padding(.top, 20)
        } else {
            EmptyView()
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

    private var navigationTitle: some View {
        HStack(spacing: 4) {
            Image(systemName: "paintbrush.fill")
            Text("Configuration de l'activité")
        }
        .font(defaults.semi17)
    }

    private var testButton: some View {
        Button(
            action: {
                gameEngine.setupGame()
                dismiss()
            },
            label: {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                    Text("Tester")
                }
            }
        )
        .disabled(configuration.testIsDisabled)
    }

    private var editionMenu: some View {
        Menu {
            Button("Tester la démo") {
                gameEngine.bufferActivity = DemoActivity().makeBufferActivity()
                configuration.setupEditor(with: gameEngine.bufferActivity)
                configuration.disableEditor = true
                configuration.testIsDisabled = false
                configuration.editorIsEmpty = false
            }
            // Pick a model to start with (create those when -> Yams)
            // Refactor: - Use ForEach(model)
            Menu("Choisir un modèle") {
                Button("1 groupe") {
                    gameEngine.bufferActivity = OneGroup().makeEmptyActivity()
                    prepareForTesting()
                }
                Button("1 groupe répété") {
                    gameEngine.bufferActivity = OneGroupRepeated().makeEmptyActivity()
                    prepareForTesting()
                }
                Button("1 groupe - Alter.") {
                    gameEngine.bufferActivity = OneGroupAlternatives().makeEmptyActivity()
                    prepareForTesting()
                }
                Button("2 groupes") {
                    gameEngine.bufferActivity = TwoIdenticalGroups().makeEmptyActivity()
                    prepareForTesting()
                }
                Button("3 groupes") {
                    gameEngine.bufferActivity = ThreeGroups().makeEmptyActivity()
                    prepareForTesting()
                }
            }
            Button("Importer") {
                // Show Alert to confirm deletion first
                triggerSoonAlert.toggle()
            }
            Divider()
            Button("Exporter") {
                // share as yaml file with ShareLink Button
            }
            .disabled(true)  // change that when Export is ready
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "doc.richtext")
                Text("Édition")
            }
        }
    }

    private func prepareForTesting() {
        configuration.setupEditor(with: gameEngine.bufferActivity)
        gameEngine.bufferActivity.id = UUID()
        defaults.playGridBtnSize = 200
        defaults.horizontalCellSpacing = 32
        defaults.verticalCellSpacing = 32
        configuration.disableEditor = false
        configuration.testIsDisabled = false
        configuration.editorIsEmpty = false
    }
}

struct ActivityConfigurator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityConfigurator()
            .environmentObject(GameEngine())
            .environmentObject(GameLayoutTemplatesDefaults())
            .environmentObject(GameLayoutTemplatesConfigurations())
    }
}
