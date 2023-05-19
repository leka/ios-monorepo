//
//  GameplayKitVM.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 23/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Foundation
import GameplayKit

class GKStateExtended: GKState {
    private var onEnter: () -> Void
    private var onExit: () -> Void

    init(onEnter: @escaping () -> Void, onExit: @escaping () -> Void) {
        self.onEnter = onEnter
        self.onExit = onExit

        super.init()
    }

    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        self.onEnter()
    }

    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        self.onExit()
    }
}

class GameplayKitVM: ObservableObject {
    @Published var currentState: String = ""

    private func fooo(on eventType: String) {
        print("[GameplayKit] fooo called on \(eventType)")
    }

    class StateA: GKStateExtended {
    }
    class StateB: GKStateExtended {
    }
    class StateC: GKStateExtended {
    }

    var stateMachine: GKStateMachine?

    init() {
        self.stateMachine = GKStateMachine(states: [
            StateA(
                onEnter: {
                    self.fooo(on: "entering state A")
                },
                onExit: {
                    self.fooo(on: "exiting state A")
                }),
            StateB(
                onEnter: {
                    self.fooo(on: "entering state B")
                },
                onExit: {
                    self.fooo(on: "exiting state B")
                }),
            StateC(
                onEnter: {
                    self.fooo(on: "entering state C")
                },
                onExit: {
                    self.fooo(on: "exiting state C")
                }),
        ]
        )

        self.stateMachine?.enter(StateA.self)
    }

    func eventA() {
        guard let stateMachine = stateMachine else { return }
        guard let state = stateMachine.currentState else { return }

        var successOnEnter = false
        switch state {
            case is StateA:
                successOnEnter = stateMachine.enter(StateB.self)
            case is StateB:
                successOnEnter = stateMachine.enter(StateC.self)
            case is StateC:
                successOnEnter = stateMachine.enter(StateA.self)
            default:
                print("UNKNOWN TRANSITION")
                successOnEnter = false
        }
        if successOnEnter {
            self.fooo(on: "transition")
        }
    }

    func eventB() {
        guard let stateMachine = stateMachine else { return }
        guard let state = stateMachine.currentState else { return }

        switch state {
            case is StateC:
                stateMachine.enter(StateC.self)
            default:
                print("UNKNOWN TRANSITION")
        }
    }
}

extension GameplayKitVM {
    func setNewState() {
        guard let stateMachine = stateMachine else { return }
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
