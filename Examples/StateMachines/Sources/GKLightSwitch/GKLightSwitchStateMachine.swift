//
//  GKLightSwitchStateMachine.swift
//  StateMachines
//
//  Created by Ladislas de Toldi on 26/05/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import GameplayKit

// swiftlint:disable identifier_name

// States:
//  *off    + pressed --> green
//   green  + pressed --> off
//   red    + pressed --> off
//
//   off    + turned --> n/a
//   green  + turned --> red
//   red    + turned --> green

public enum LightState {
    case off
    case green
    case red
}

public enum SwitchEvent {
    case turned
    case pressed
}

protocol SwitchEventProcessor {
    func process(event: SwitchEvent)
}

class OffState: GKState, SwitchEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GreenState.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("Light is now OFF, was \(String(describing: previousState))")
    }

    func process(event: SwitchEvent) {
        guard let stateMachine = self.stateMachine else {
            return
        }
        switch event {
            case .pressed:
                stateMachine.enter(GreenState.self)
            default:
                return
        }
    }

}

class GreenState: GKState, SwitchEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is OffState.Type || stateClass is RedState.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("Light is now GREEN, was \(String(describing: previousState))")
    }

    func process(event: SwitchEvent) {
        guard let stateMachine = self.stateMachine else {
            return
        }
        switch event {
            case .pressed:
                stateMachine.enter(OffState.self)
            case .turned:
                stateMachine.enter(RedState.self)
        }
    }

}

class RedState: GKState, SwitchEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is OffState.Type || stateClass is GreenState.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("Light is now RED, was \(String(describing: previousState))")
    }

    func process(event: SwitchEvent) {
        guard let stateMachine = self.stateMachine else {
            return
        }
        switch event {
            case .pressed:
                stateMachine.enter(OffState.self)
            case .turned:
                stateMachine.enter(GreenState.self)
        }
    }

}

class LightStateMachine {

    static let states: [GKState] = [
        OffState(),
        GreenState(),
        RedState(),
    ]

    private let stateMachine: GKStateMachine = GKStateMachine(states: states)

    init() {
        stateMachine.enter(OffState.self)
    }

    public var state: LightState {
        guard let state = stateMachine.currentState else {
            return .off
        }
        switch state {
            case is OffState:
                return .off
            case is GreenState:
                return .green
            case is RedState:
                return .red
            default:
                return .off
        }
    }

    public func process(event: SwitchEvent) {
        guard let state = stateMachine.currentState as? any SwitchEventProcessor else {
            return
        }
        state.process(event: event)
    }

}

// swiftlint:enable identifier_name
