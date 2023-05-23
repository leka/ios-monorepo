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

    enum State: Sendable {
        case stateA, stateB, stateC
    }

    enum Action: Sendable {
        case eventA, eventB
    }

    struct LoginFlowEffectID: EffectIDProtocol {}

    struct Environment {
        let fooo: () -> Void
    }

    let environment: Environment
    let reducer: Reducer<Action, State, Environment>
    let actomaton: Actomaton<Action, State>

    init() {
        environment = Environment(
            fooo: {}
        )

        reducer = Reducer { action, state, environment in
            switch (action, state) {
                case (.eventA, .stateA):
                    state = .stateB
                    environment.fooo()
                    return .empty

                case (.eventA, .stateB):
                    state = .stateC
                    return .empty

                case (.eventA, .stateC),
                    (.eventB, .stateC):
                    state = .stateA
                    return .empty

                default:
                    return Effect.fireAndForget {
                        print("State transition failed...")
                    }
            }
        }

        actomaton = Actomaton<Action, State>(
            state: .stateA,
            reducer: reducer,
            environment: environment
        )
    }

}

extension ActomatonVM {
    func setNewState() {
        Task {
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
        Task { await actomaton.send(.eventA) }
        setNewState()
    }
}
