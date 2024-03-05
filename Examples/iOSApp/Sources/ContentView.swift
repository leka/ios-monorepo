// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Module
import SwiftUI

// MARK: - DataManager

class DataManager {
    // MARK: Lifecycle

    private init() {
        // nothing to do yet
    }

    // MARK: Public

    public static let shared: DataManager = .init()

    public var counter: CurrentValueSubject<Int, Never> = .init(0)

    public func increment() {
        self.counter.value += 1
    }

    public func decrement() {
        self.counter.value -= 1
    }
}

// MARK: - GlobalViewModel

class GlobalViewModel: ObservableObject {
    // MARK: Lifecycle

    init() {
        self.dataManager.counter
            .sink { [weak self] value in
                self?.counter = value
                print("received new counter: \(value)")
            }
            .store(in: &self.cancellables)
    }

    // MARK: Internal

    @Published var counter = 0

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []
    private let dataManager: DataManager = .shared
}

// MARK: - ViewA

struct ViewA: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Text("View A: \(self.viewModel.counter)")
            Button("local increment counter") {
                self.dataManager.increment()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: Private

    @StateObject private var viewModel = GlobalViewModel()
    private let dataManager: DataManager = .shared
}

// MARK: - ViewB

struct ViewB: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Text("View B: \(self.viewModel.counter)")
            Button("local decrement counter") {
                self.dataManager.decrement()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: Private

    @StateObject private var viewModel = GlobalViewModel()
    private let dataManager: DataManager = .shared
}

// MARK: - DetailView

struct DetailView: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Text("Global counter: \(self.viewModel.counter)")
                .padding()
                .font(.title)

            Button("global increment counter") {
                self.dataManager.increment()
            }
            .buttonStyle(.borderedProminent)

            Button("global decrement counter") {
                self.dataManager.decrement()
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Detail View")
    }

    // MARK: Private

    @StateObject private var viewModel = GlobalViewModel()
    private let dataManager: DataManager = .shared
}

// MARK: - ContentView

struct ContentView: View {
    // MARK: Internal

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ViewA()
                    Spacer()
                    ViewB()
                }
                .padding(100)

                Text("Global counter: \(self.viewModel.counter)")
                    .padding()
                    .font(.title)

                Button("global increment counter") {
                    self.dataManager.increment()
                }
                .buttonStyle(.borderedProminent)

                Button("global decrement counter") {
                    self.dataManager.decrement()
                }
                .buttonStyle(.borderedProminent)

                NavigationLink(destination: DetailView()) {
                    Text("Show Detail View")
                }

                HStack {
                    ViewA()
                    Spacer()
                    ViewB()
                }
                .padding(100)
            }
            .navigationTitle("Main View")
        }
    }

    // MARK: Private

    @StateObject private var viewModel = GlobalViewModel()
    private let dataManager: DataManager = .shared
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
