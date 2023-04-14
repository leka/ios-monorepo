// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityTitleAndShort: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @Binding var language: Languages
    @State private var title: String = ""
    @State private var titleIsEditing: Bool = false
    @State private var short: String = ""
    @State private var shortIsEditing: Bool = false

    var body: some View {
        Section {
            Group {
                editTitle
                editShort
            }
        } header: {
            Text("Titre & Abréviation")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
        .onChange(of: language) { newValue in
            switch newValue {
                case .french:
                    title = gameEngine.bufferActivity.title.frFR!
                    short = gameEngine.bufferActivity.short.frFR!
                case .english:
                    title = gameEngine.bufferActivity.title.enUS!
                    short = gameEngine.bufferActivity.short.enUS!
            }
        }
        .onChange(
            of: gameEngine.bufferActivity,
            perform: { _ in
                switch language {
                    case .french:
                        title = gameEngine.bufferActivity.title.frFR!
                        short = gameEngine.bufferActivity.short.frFR!
                    case .english:
                        title = gameEngine.bufferActivity.title.enUS!
                        short = gameEngine.bufferActivity.short.enUS!
                }
            })
    }

    private var editTitle: some View {
        LabeledContent {
            TextField("", text: $title) { isEditing in titleIsEditing = isEditing }
                .keyboardType(.default)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.horizontal, 10)
                .frame(height: 34)
                .frame(minWidth: 350, maxWidth: 500)
                .foregroundColor(Color("lekaSkyBlue"))
                .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(titleIsEditing ? Color("lekaSkyBlue") : .gray.opacity(0.2), lineWidth: 1)
                )
                .onSubmit {
                    switch language {
                        case .french: gameEngine.bufferActivity.title.frFR = title
                        case .english: gameEngine.bufferActivity.title.enUS = title
                    }
                }
        } label: {
            Text("Titre de l'activité")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .onAppear {
            title = {
                switch language {
                    case .french: return gameEngine.bufferActivity.title.frFR!
                    case .english: return gameEngine.bufferActivity.title.enUS!
                }
            }()
        }
    }

    private var editShort: some View {
        LabeledContent {
            TextField("", text: $short) { isEditing in shortIsEditing = isEditing }
                .keyboardType(.default)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .padding(.horizontal, 10)
                .frame(height: 34)
                .frame(minWidth: 350, maxWidth: 500)
                .foregroundColor(Color("lekaSkyBlue"))
                .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(shortIsEditing ? Color("lekaSkyBlue") : .gray.opacity(0.2), lineWidth: 1)
                )
                .onSubmit {
                    switch language {
                        case .french: gameEngine.bufferActivity.short.frFR = short
                        case .english: gameEngine.bufferActivity.short.enUS = short
                    }
                }
        } label: {
            Text("Abréviation")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .onAppear {
            short = {
                switch language {
                    case .french: return gameEngine.bufferActivity.short.frFR!
                    case .english: return gameEngine.bufferActivity.short.enUS!
                }
            }()
        }
    }
}
