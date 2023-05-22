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

    enum State: StateType {
        case stateA, stateB, stateC
    }

    enum Event: EventType {
        case eventA, eventB
    }

    let machine = StateMachine<State, Event>(state: .stateA) { machine in
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

        //        // add handler (`context = (event, fromState, toState, userInfo)`)
        //        machine.addHandler(.stateC => .stateA) { context in
        //            print("Transition from state C to state A")
        //        }

        machine.addHandler(event: .eventA) { _ in
            print("eventA triggered!")
        }
    }
}

extension ReactKitVM {
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
        machine.tryEvent(.eventA)
        setNewState()
    }
}
