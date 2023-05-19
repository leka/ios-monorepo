//
//  ActomatonVM.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Actomaton
import Foundation

class ActomatonVM: ObservableObject {
    @Published var currentState: String = ""

    private func fooo(on eventType: String) {
        print("[Actomaton] fooo called on \(eventType)")
    }

    enum State: Sendable {
        case stateA, stateB, stateC
    }

    enum Action: Sendable {
        case eventA, eventB
    }

    typealias Environment = Void

    var reducer: Reducer<Action, State, Environment>?
    var actomaton: Actomaton<Action, State>?

    init() {
        self.reducer = Reducer { action, state, environment in
            switch (action, state) {
                case (.eventA, .stateA):
                    self.fooo(on: "exiting state A")
                    self.fooo(on: "transition")
                    state = .stateB
                    self.fooo(on: "entring state B")
                    return .empty

                case (.eventA, .stateB):
                    self.fooo(on: "exiting state B")
                    self.fooo(on: "transition")
                    state = .stateC
                    self.fooo(on: "entring state C")
                    return .empty

                case (.eventA, .stateC),
                    (.eventB, .stateC):
                    self.fooo(on: "exiting state C")
                    self.fooo(on: "transition")
                    state = .stateA
                    self.fooo(on: "entring state A")
                    return .empty

                default:
                    return Effect.fireAndForget {
                        print("State transition failed...")
                    }
            }
        }

        self.actomaton = Actomaton<Action, State>(
            state: .stateA,
            reducer: reducer!
        )
    }

}

extension ActomatonVM {
    func setNewState() {
        Task {
            guard let actomaton = actomaton else { return }

            switch await actomaton.state {
                case .stateA:
                    currentState = "state A"
                case .stateB:
                    currentState = "state B"
                case .stateC:
                    currentState = "state C"
            }
        }
    }

    func somethingHappens() {
        Task {
            guard let actomaton = actomaton else { return }

            await actomaton.send(.eventA)
        }
        setNewState()
    }
}
