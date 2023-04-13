//
//  StepEditor.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 3/4/23.
//

import SwiftUI

struct StepEditor: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var configuration: GLT_Configurations
    @EnvironmentObject var defaults: GLT_Defaults

    @Binding var rank: Int
    @Binding var step: Step
    @Binding var language: Languages

    @State private var textIsEditing: Bool = false
    @State private var text: String = ""
    @State private var triggerMinimumAnswersAlert: Bool = false

    // TODO: Place alerts, make good answer, finish editStepAnswers + make addNewAnswer

    var body: some View {
        Section {
            Group {
                //				ItemIDGenerator(forID: $step.id, label: "ID de l'étape #\(rank)")
                editStepInstruction
                // HERE optional layouts (3, 4, 6)
                editStepAnswers
                // correctAnswer
                // Sounds toggle + mediaPicker
            }
            .frame(minHeight: 50)
            .padding(.leading, 30)
        } header: {
            Text("Étape #\(rank)")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
        .disabled(configuration.disableEditor)
    }

    @ViewBuilder
    private var editStepAnswers: some View {
        List {
            Section {
                ForEach(step.allAnswers.enumerated().map({ $0 }), id: \.offset) { index, answer in
                    answerRow(rank: index, answer: answer)
                        .deleteDisabled(configuration.disableEditor || step.allAnswers.count < 2)
                }
                .onDelete { offset in step.allAnswers.remove(atOffsets: offset) }
            } header: {
                Text("Ajouter ou supprimer (swipe left) des réponses et les éditer")
                    .foregroundColor(Color("darkGray").opacity(0.5))
            } footer: {
                addNewAnswer
            }
        }
    }

    private func answerRow(rank: Int, answer: String) -> some View {
        LabeledContent {
            CircularPreviewAnswerContent(content: answer)
        } label: {
            Text("Réponse #\(rank+1)")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .frame(minHeight: 35)
    }

    @ViewBuilder
    private var addNewAnswer: some View {
        // edit this so that the added answer is indeed the one following the last (if last = 3, 4)
        // + alert when too many or not enough answers
        Group {
            if gameEngine.bufferActivity.stepsAmount != gameEngine.bufferActivity.stepSequence.joined().count {
                Button("Ajouter une nouvelle étape") {
                    let delta =
                        gameEngine.bufferActivity.stepsAmount - gameEngine.bufferActivity.stepSequence.joined().count
                    let emptyStep = Step()
                    gameEngine.bufferActivity.stepSequence.append(Array(repeating: emptyStep, count: delta))
                }
            } else {
                EmptyView()
            }
        }
        .foregroundColor(Color("lekaSkyBlue"))
        .frame(minHeight: 35)
        .padding(.leading, 30)
    }

    private var correctAnswer: some View {
        Text("Correct answer name or Index???")  // select amongst available ones!!!
    }

    private var soundToggle: some View {
        Text("Toggle to use sound + diplay button to soundSelector if yes")  // not necessary at first. Use one sound maybe?
    }

    private var editStepInstruction: some View {
        LabeledContent {
            TextField("", text: $text) { isEditing in textIsEditing = isEditing }
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
                        .stroke(textIsEditing ? Color("lekaSkyBlue") : .gray.opacity(0.2), lineWidth: 1)
                )
                .onSubmit {
                    switch language {
                        case .french: step.instruction.frFR = text
                        case .english: step.instruction.enUS = text  //gameEngine.bufferActivity.stepSequence[0][0].instruction.enUS = text//
                    }
                }
        } label: {
            Text("Consigne de l'étape :")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .onAppear {
            text = {
                switch language {
                    case .french: return step.instruction.frFR!
                    case .english: return step.instruction.enUS!
                }
            }()
        }
        .onChange(of: language) { newValue in
            text = {
                switch newValue {
                    case .french: return step.instruction.frFR!
                    case .english: return step.instruction.enUS!
                }
            }()
        }
    }
}
