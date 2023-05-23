//
//  GameplayKitVM.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Foundation
import GameplayKit

class GameplayKitVM: ObservableObject {
    @Published var currentState: String = ""

    class StateA: GKState {
    }
    class StateB: GKState {
    }
    class StateC: GKState {
    }

    var stateMachine: GKStateMachine

    init() {
        stateMachine = GKStateMachine(states: [
            StateA(),
            StateB(),
            StateC(),
        ])

        stateMachine.enter(StateA.self)
    }

    func eventA() {
        guard let state = stateMachine.currentState else { return }

        switch state {
            case is StateA:
                stateMachine.enter(StateB.self)
            case is StateB:
                stateMachine.enter(StateC.self)
            case is StateC:
                stateMachine.enter(StateA.self)
            default:
                print("UNKNOWN TRANSITION")
        }
    }
}

extension GameplayKitVM {
    func setNewState() {
        guard let state = stateMachine.currentState else { return }

        switch state {
            case is StateA:
                currentState = "state A"
            case is StateB:
                currentState = "state B"
            case is StateC:
                currentState = "state C"
            default:
                currentState = "UNKNOWN STATE"
        }
    }

    func somethingHappens() {
        eventA()
        setNewState()
    }
}
