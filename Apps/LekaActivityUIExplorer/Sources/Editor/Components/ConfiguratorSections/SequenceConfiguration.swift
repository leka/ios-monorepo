//
//  GroupConfiguration.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 2/4/23.
//

import SwiftUI

struct SequenceConfiguration: View {

    @EnvironmentObject var configuration: GLT_Configurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GLT_Defaults

    @State private var goToGroupEditor: Bool = false

    var body: some View {
        Section {
            //			randomGroupsToggle
            List {
                Section {
                    ForEach(gameEngine.bufferActivity.stepSequence.indices, id: \.self) { index in
                        groupRow(rank: index)
                            .deleteDisabled(
                                configuration.disableEditor || gameEngine.bufferActivity.stepSequence.count < 2)
                    }
                    .onDelete { offset in
                        gameEngine.bufferActivity.stepSequence.remove(atOffsets: offset)
                        configuration.originalSteps = gameEngine.bufferActivity.stepSequence
                    }
                } header: {
                    Text("Ajouter ou supprimer (swipe left) des groupes & modifier leurs étapes")
                        .foregroundColor(Color("darkGray").opacity(0.5))
                } footer: {
                    addNewGroup
                        .disabled(configuration.disableEditor)
                }
            }
        } header: {
            Text("Séquence")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
        .navigationDestination(isPresented: $goToGroupEditor) { GroupEditor() }
    }

    @ViewBuilder
    private var addNewGroup: some View {
        Group {
            if gameEngine.bufferActivity.stepsAmount != gameEngine.bufferActivity.stepSequence.joined().count {
                Button("Ajouter un nouveau groupe") {
                    let delta =
                        gameEngine.bufferActivity.stepsAmount - gameEngine.bufferActivity.stepSequence.joined().count
                    let emptyStep = EmptyDataSets().emptyStep()
                    gameEngine.bufferActivity.stepSequence.append(Array(repeating: emptyStep, count: delta))
                    configuration.originalSteps = gameEngine.bufferActivity.stepSequence
                }
            } else {
                EmptyView()
            }
        }
        .foregroundColor(Color("lekaSkyBlue"))
        .frame(minHeight: 35)
        .padding(.leading, 30)
    }

    private func repeated() -> String {
        guard gameEngine.bufferActivity.stepSequence.count == 1 else {
            return ""
        }
        guard gameEngine.bufferActivity.stepsAmount.isMultiple(of: gameEngine.bufferActivity.stepSequence[0].count)
        else {
            return ""
        }
        let multiplier = gameEngine.bufferActivity.stepsAmount / gameEngine.bufferActivity.stepSequence[0].count
        return multiplier != 1 ? "(x\(multiplier))" : ""
    }

    private func groupRow(rank: Int) -> some View {
        LabeledContent {
            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing: 10) {
                    Text("\(configuration.originalSteps[rank].count) étapes \(repeated())")
                        .font(defaults.reg17)
                        .foregroundColor(Color("darkGray").opacity(0.5))
                        .padding(.horizontal, 20)
                        .frame(height: 34)
                        .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray.opacity(0.2), lineWidth: 1)
                        )

                    Button(action: {
                        configuration.currentlyEditedGroupIndex = rank
                        goToGroupEditor.toggle()
                    }) {
                        Text("Éditer")
                            .font(defaults.reg15)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .frame(height: 34)
                            .background(Color("lekaSkyBlue"), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                .frame(width: 220)
            }

        } label: {
            Text("Groupe #\(rank+1)")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .frame(minHeight: 35)
    }
}
