// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    let threeInlineGameplay = [
        oneAnswerThreeInlineGameplay, allAnswersThreeInlineGameplay, someAnswersThreeInlineGameplay,
    ]
    let sixGridGameplay = [oneAnswerSixGridGameplay, allAnswersSixGridGameplay, someAnswersSixGridGameplay]

    var body: some View {
        Grid(
            horizontalSpacing: 30,
            verticalSpacing: 30
        ) {
            GridRow {
                ForEach(0..<3) { index in
                    NavigationLink {

                        ThreeChoicesInlineView(gameplay: threeInlineGameplay[index])
                    } label: {
                        VStack {
                            Text("Type d'interfaces : \n Three Choices Inline")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(5)
                            Text("Gameplay : \(index)")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(5)
                        }
                        .background(.blue.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary)
                        )
                    }
                }
            }

            GridRow {
                ForEach(0..<3) { index in
                    NavigationLink {

                        SixChoicesGridView(gameplay: sixGridGameplay[index])
                    } label: {
                        VStack {
                            Text("Type d'interfaces : \n Six Choices Grid")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(5)
                            Text("Gameplay : \(index)")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(5)
                        }
                        .background(.blue.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary)
                        )
                    }
                }
            }
        }
    }
}
