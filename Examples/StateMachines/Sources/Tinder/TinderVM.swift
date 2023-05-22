//
//  TinderVM.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 19/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Foundation

class TinderVM: StateMachineBuilder, ObservableObject {
    @Published var currentState: String = ""

    enum State: StateMachineHashable {
        case stateA, stateB, stateC
    }

    enum Event: StateMachineHashable, CaseIterable {
        case eventA, eventB
    }

    enum SideEffect {
        case logAtoB, logBtoC, logCtoA
    }

    private let machine = TinderStateMachine<State, Event, SideEffect> {
        initialState(.stateA)
        state(.stateA) {
            on(.eventA) {
                transition(to: .stateB, emit: .logAtoB)
            }
        }
        state(.stateB) {
            on(.eventA) {
                transition(to: .stateC, emit: .logBtoC)
            }
        }
        state(.stateC) {
            on(.eventA) {
                transition(to: .stateA, emit: .logCtoA)
            }
            on(.eventB) {
                transition(to: .stateC)
            }
        }
        onTransition {
            guard case let .success(transition) = $0, let sideEffect = transition.sideEffect else { return }
            switch sideEffect {
                case .logAtoB: print("Transition from state A to state B")
                case .logBtoC: print("Transition from state B to state C")
                case .logCtoA: print("Transition from state C to state A")
            }
        }
    }
}

extension TinderVM {
    func setNewState() {
        switch machine.state {
            case .stateA:
                currentState = "state A"
            case .stateB:
                currentState = "state B"
            case .stateC:
                currentState = "state C"
        }
    }

    func somethingHappens() {
        do {
            try machine.transition(.eventA)
        } catch {
            print("not a possible transition")
        }
        setNewState()
    }
}
