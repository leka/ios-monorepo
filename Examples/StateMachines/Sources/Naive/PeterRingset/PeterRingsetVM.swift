//
//  PeterRingsetVM.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 24/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Combine
import Foundation

class PeterRingsetVM: ObservableObject {
    @Published var currentState: String = ""

    private func fooo(on eventType: String) {
        print("[PeterRingset] fooo called on \(eventType)")
    }

    private let stateMachine = PRStateMachine()

    init() {
        self.currentState = "state A"

        stateMachine.statePublisher
            .sink { state in
                self.fooo(on: "entering state")

                switch state {
                    case .stateA:
                        self.currentState = "state A"
                    case .stateB:
                        self.currentState = "state B"
                    case .stateC:
                        self.currentState = "state C"
                }
            }
            .store(in: &stateMachine.stateCancellable)

        stateMachine.onEventSucceded = {
            self.fooo(on: "transition")
        }
    }
}

extension PeterRingsetVM {
    func setNewState() {
        // nothing to implement
    }

    func somethingHappens() {
        stateMachine.tryEvent(.eventA)
    }
}
