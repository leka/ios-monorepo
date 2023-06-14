// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {
    let threeInlineVM = [oneAnswerThreeInlineVM, allAnswersThreeInlineVM, someAnswersThreeInlineVM]
    let sixGridVM = [oneAnswerSixGridVM, allAnswersSixGridVM, someAnswersSixGridVM]

    var body: some View {
        Grid(
            horizontalSpacing: 30,
            verticalSpacing: 30
        ) {
            GridRow {
                ForEach(threeInlineVM) { viewModel in
                    NavigationLink {
                        Text(viewModel.gameplay.name)
                            .font(.title)

                        ThreeChoicesInlineView(viewModel: viewModel)
                    } label: {
                        VStack {
                            Text("Type d'interfaces : \n \(viewModel.name)")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(5)
                            Text("Gameplay : \n \(viewModel.gameplay.name)")
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
                ForEach(sixGridVM) { viewModel in
                    NavigationLink {
                        Text(viewModel.gameplay.name)
                            .font(.title)

                        SixChoicesGridView(viewModel: viewModel)
                    } label: {
                        VStack {
                            Text("Type d'interfaces : \n \(viewModel.name)")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(5)
                            Text("Gameplay : \n \(viewModel.gameplay.name)")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
