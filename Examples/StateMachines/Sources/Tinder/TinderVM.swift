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

    private func fooo(on eventType: String) {
        print("[Tinder] fooo called on \(eventType)")
    }

    enum State: StateMachineHashable {
        case stateA, stateB, stateC
    }

    enum Event: StateMachineHashable, CaseIterable {
        case eventA, eventB
    }

    enum SideEffect {
        case logAtoB, logBtoC, logCtoA
    }

    private var machine: TinderStateMachine<State, Event, SideEffect>?

    init() {
        self.machine = TinderStateMachine<State, Event, SideEffect> {
            Self.initialState(.stateA)
            Self.state(.stateA) {
                Self.on(.eventA) {
                    Self.transition(to: .stateB, emit: .logAtoB)
                }
            }
            Self.state(.stateB) {
                Self.on(.eventA) {
                    Self.transition(to: .stateC, emit: .logBtoC)
                }
            }
            Self.state(.stateC) {
                Self.on(.eventA) {
                    Self.transition(to: .stateA, emit: .logCtoA)
                }
                Self.on(.eventB) {
                    Self.transition(to: .stateC)
                }
            }
            Self.onTransition {
                guard case let .success(transition) = $0, let sideEffect = transition.sideEffect else { return }
                switch sideEffect {
                    case .logAtoB: self.fooo(on: "transition from state A to state B")
                    case .logBtoC: self.fooo(on: "transition from state B to state C")
                    case .logCtoA: self.fooo(on: "transition from state C to state A")
                }
            }
        }
    }
}

extension TinderVM {
    func setNewState() {
        guard let machine = machine else { return }

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
        guard let machine = machine else { return }

        do {
            try machine.transition(.eventA)
        } catch {
            print("not a possible transition")
        }
        setNewState()
    }
}
