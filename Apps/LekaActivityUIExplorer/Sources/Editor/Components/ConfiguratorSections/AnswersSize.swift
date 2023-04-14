//
//  AnswersSize.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 6/4/23.
//

import SwiftUI

struct AnswersSize: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @State private var size = 0
    @State private var hSpacing = 0
    @State private var vSpacing = 0

    var body: some View {
        Section {
            Group {
                editSize
                editHorizontalSpacing
                editVerticalSpacing
            }
        } header: {
            Text("Taille & Espacement des réponses")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        } footer: {
            HStack {
                Spacer()
                Button(
                    action: {
                        defaults.playGridBtnSize = 200
                        defaults.horizontalCellSpacing = 32
                        defaults.verticalCellSpacing = 32
                        size = 200
                        hSpacing = 32
                        vSpacing = 32
                    },
                    label: {
                        HStack(spacing: 6) {
                            Text("Valeurs par défaut")
                            Image(systemName: "arrow.counterclockwise.circle")
                        }
                        .font(defaults.reg15)
                        .foregroundColor(.accentColor)
                        .contentShape(Rectangle())
                    })
            }
        }
        .onChange(
            of: gameEngine.bufferActivity,
            perform: { _ in
                size = Int(defaults.playGridBtnSize)
                hSpacing = Int(defaults.horizontalCellSpacing)
                vSpacing = Int(defaults.verticalCellSpacing)
            })
    }

    private var editSize: some View {
        LabeledContent {
            TextField("", value: $size, format: .number)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 10)
                .frame(height: 34)
                .frame(minWidth: 350, maxWidth: 500)
                .foregroundColor(Color("lekaSkyBlue"))
                .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .onSubmit {
                    defaults.playGridBtnSize = CGFloat(size)
                }
        } label: {
            Text("Taille des réponses")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .onAppear { size = Int(defaults.playGridBtnSize) }
    }

    private var editHorizontalSpacing: some View {
        LabeledContent {
            TextField("", value: $hSpacing, format: .number)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 10)
                .frame(height: 34)
                .frame(minWidth: 350, maxWidth: 500)
                .foregroundColor(Color("lekaSkyBlue"))
                .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .onSubmit {
                    defaults.horizontalCellSpacing = CGFloat(hSpacing)
                }
        } label: {
            Text("Espacement horizontal")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .onAppear { hSpacing = Int(defaults.horizontalCellSpacing) }
    }

    private var editVerticalSpacing: some View {
        LabeledContent {
            TextField("", value: $vSpacing, format: .number)
                .keyboardType(.decimalPad)
                .padding(.horizontal, 10)
                .frame(height: 34)
                .frame(minWidth: 350, maxWidth: 500)
                .foregroundColor(Color("lekaSkyBlue"))
                .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.2), lineWidth: 1)
                )
                .onSubmit {
                    defaults.verticalCellSpacing = CGFloat(vSpacing)
                }
        } label: {
            Text("Espacement vertical")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .onAppear { vSpacing = Int(defaults.verticalCellSpacing) }
    }
}
