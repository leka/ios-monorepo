//
//  PRStateMachine.swift
//  StateMachines
//
//  Created by Yann LOCATELLI on 24/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Combine
import Foundation

class PRStateMachine {
    enum State {
        case stateA, stateB, stateC
    }

    enum Event {
        case eventA, eventB
    }

    // The machine stores the current state in a variable that is read-only, and offers a publisher that notifies any listeners every time the state is changed internally.
    private(set) var state: State {
        didSet { stateSubject.send(self.state) }
    }
    private let stateSubject: PassthroughSubject<State, Never>
    let statePublisher: AnyPublisher<State, Never>

    var stateCancellable = Set<AnyCancellable>()

    init() {
        self.state = .stateA
        self.stateSubject = PassthroughSubject<State, Never>()
        self.statePublisher = self.stateSubject
            .eraseToAnyPublisher()
    }

    var onEventSucceded: (() -> Void)?
}

extension PRStateMachine {

    func tryEvent(_ event: Event) {
        if let state = nextState(for: event) {
            self.onEventSucceded?()
            self.state = state
        }
    }

    private func nextState(for event: Event) -> State? {
        switch state {
            case .stateA:
                switch event {
                    case .eventA: return .stateB
                    default: return nil
                }
            case .stateB:
                switch event {
                    case .eventA: return .stateC
                    default: return nil
                }
            case .stateC:
                switch event {
                    case .eventA: return .stateA
                    case .eventB: return .stateC
                }
        }
    }
}
