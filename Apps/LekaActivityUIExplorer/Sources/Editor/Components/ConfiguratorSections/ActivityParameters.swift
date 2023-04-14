// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ActivityParameters: View {

    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var buttonRotation: Double = 0

    var body: some View {
        Section {
            Group {
                ItemIDGenerator(forID: $gameEngine.bufferActivity.id, label: "ID de l'activité")
                typePicker
                totalOfSteps
                randomStepsToggle
            }
        } header: {
            Text("Paramètres")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }

    private var randomStepsToggle: some View {
        LabeledContent {
            Toggle("", isOn: $gameEngine.bufferActivity.isRandom)
                .toggleStyle(SwitchToggleStyle(tint: Color("lekaSkyBlue")))
                .labelsHidden()
        } label: {
            Text("L'ordre des étapes est aléatoire")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
    }

    private var totalOfSteps: some View {
        LabeledContent {
            VStack(alignment: .trailing, spacing: 10) {
                HStack(spacing: 10) {
                    Text("\(gameEngine.bufferActivity.stepsAmount)")
                        .font(defaults.reg17)
                        .foregroundColor(Color("darkGray").opacity(0.5))
                        .padding(.horizontal, 10)
                        .frame(width: 100, height: 34)
                        .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray.opacity(0.2), lineWidth: 1)
                        )
                    Stepper(
                        label: {
                            EmptyView()
                        },
                        onIncrement: {
                            gameEngine.bufferActivity.stepsAmount += 1
                        },
                        onDecrement: {
                            guard gameEngine.bufferActivity.stepsAmount > 2 else {
                                return
                            }
                            gameEngine.bufferActivity.stepsAmount -= 1
                        }
                    )
                    .foregroundColor(.accentColor)
                }
                .frame(width: 220)

                if gameEngine.bufferActivity.stepSequence.count == 1 {
                    if !gameEngine.bufferActivity.stepsAmount.isMultiple(
                        of: gameEngine.bufferActivity.stepSequence[0].count)
                    {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(
                                "Attention, \(gameEngine.bufferActivity.stepsAmount) n'est pas un multiple de \(gameEngine.bufferActivity.stepSequence[0].count) (nombre d'étapes dans la séquence actuellement)."
                            )
                        }
                        .font(defaults.reg13)
                        .foregroundColor(.red)
                    } else {
                        EmptyView()
                    }
                } else if gameEngine.bufferActivity.stepsAmount != gameEngine.bufferActivity.stepSequence.joined().count
                {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(
                            "Attention, le nombre total d'étapes saisi (\(gameEngine.bufferActivity.stepsAmount)) est différent du nombre d'étapes actuellement dans la séquence (\(gameEngine.bufferActivity.stepSequence.joined().count))."
                        )
                    }
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.red)
                } else {
                    EmptyView()
                }
            }

        } label: {
            Text("Nombre total d'étapes dans l'activité")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .frame(minHeight: 35)
    }

    private var typePicker: some View {
        LabeledContent {
            Menu {
                ForEach(configuration.typesOfActivity, id: \.self) { type in
                    Button(type, action: { gameEngine.bufferActivity.activityType = type })
                }
            } label: {
                Text(gameEngine.bufferActivity.activityType ?? "touch_to_select")
                    .font(defaults.reg17)
                    .foregroundColor(Color("darkGray").opacity(0.5))
                    .padding(.horizontal, 10)
                    .frame(height: 34)
                    .frame(minWidth: 350, maxWidth: 500)
                    .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                    )
            }
        } label: {
            Text("Type de l'activité")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .frame(minHeight: 35)
    }
}
