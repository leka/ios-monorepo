// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Module
import SwiftUI

class ViewModel: ObservableObject {

    var number1: Int = 42 {
        // ? Use willSet or didSet but not both at the same time
        willSet {
            guard newValue == 4 else { return }
            print("WILL SET - newValue == 4 - calling objectWillChange.send()")
            objectWillChange.send()
        }

        // didSet {
        //     guard number1 == 4 else { return }
        //     print("DID SET - newValue == 4 - calling objectWillChange.send()")
        //     objectWillChange.send()
        // }
    }
    var number2: Int = 1337

    func randomize() {
        print("\nBEFORE randomizing numbers \(number1) - \(number2)")
        number1 = Int.random(in: 0...4)
        number2 = Int.random(in: 0...100)
        print("AFTER randomizing numbers \(number1) - \(number2)")
    }

    func update() {
        objectWillChange.send()
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
            .onReceive(viewModel.objectWillChange) {
                print("ON RECEIVE - objectWillChange - \(viewModel)")
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
