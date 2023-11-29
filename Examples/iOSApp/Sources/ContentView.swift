// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

class ViewModel: ObservableObject {

    var number1: Int = 42
    var number2: Int = 1337

    func randomize() {
        number1 = Int.random(in: 0...100)
        number2 = Int.random(in: 0...100)
        print("randomized numbers \(number1) - \(number2)")
    }

    func update() {
        objectWillChange.send()
        print("updated numbers \(number1) - \(number2)")
    }

}

struct ContentView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        Text("Number 1: \(viewModel.number1) - Number 2: \(viewModel.number2)")
            .padding()
            .onChange(of: viewModel.number1) { [oldValue = viewModel.number1] newValue in
                print("ON CHANGE - number 1 - \(oldValue) -> \(newValue)")
            }
            .onChange(of: viewModel.number2) { [oldValue = viewModel.number2] newValue in
                print("ON CHANGE - number 2 - \(oldValue) -> \(newValue)")
            }

        Button("Randomize") {
            viewModel.randomize()
        }
        .buttonStyle(.bordered)

        Button("Update") {
            viewModel.update()
        }
        .buttonStyle(.bordered)
    }

}

#Preview {
    ContentView()
}
