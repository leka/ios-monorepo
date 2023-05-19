//
//  ReactKitExample.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 22/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Foundation
import SwiftState

class ReactKitVM: ObservableObject {
    @Published var currentState: String = ""

    private func fooo(on eventType: String) {
        print("[ReactKit] fooo called on \(eventType)")
    }

    enum State: StateType {
        case stateA, stateB, stateC
    }

    enum Event: EventType {
        case eventA, eventB
    }

    var machine: StateMachine<State, Event>?

    init() {
        machine = StateMachine<State, Event>(state: .stateA) { machine in
            //        machine.addRoute(.stateA => .stateB) { _ in print("Transition from state A to state B") }
            //        machine.addRoute(.stateB => .stateC) { _ in print("Transition from state A to state B") }
            //        machine.addRoute(.any => .stateA)

            machine.addRoutes(
                event: .eventA,
                transitions: [
                    .stateA => .stateB,
                    .stateB => .stateC,
                    .stateC => .stateA,
                ])

            machine.addRoutes(
                event: .eventB,
                transitions: [
                    .stateC => .stateC
                ])

            // add handler (`context = (event, fromState, toState, userInfo)`)
            machine.addHandler(.any => .any) { context in
                self.fooo(on: "exiting & entering state")
            }

            machine.addHandler(event: .eventA) { _ in
                self.fooo(on: "transition")
            }
        }
    }
}

extension ReactKitVM {
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

        machine.tryEvent(.eventA)
        setNewState()
    }
}
