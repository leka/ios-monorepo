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
//   yellow + pressed --> off
//   red    + pressed --> off
//
//   off    + turned --> n/a
//   green  + turned --> yellow
//   green  + turned [if turn count == 5] --> red
//   yellow + turned --> green
//   red    + turned --> n/a

//
// MARK: - States, events
//

public enum LightState {
    case off
    case green
    case yellow
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

    private let switchController: SwitchController

    init(switchController: SwitchController) {
        self.switchController = switchController
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GreenState.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("Light is now OFF, was \(String(describing: previousState))")
        switchController.resetCounter()
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

    private let switchController: SwitchController

    init(switchController: SwitchController) {
        self.switchController = switchController
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if switchController.count == 5 {
            return stateClass is RedState.Type
        }
        return stateClass is OffState.Type || stateClass is YellowState.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("Light is now GREEN, was \(String(describing: previousState))")
    }

    override func willExit(to nextState: GKState) {
        switchController.incrementCounter()
    }

    func process(event: SwitchEvent) {
        guard let stateMachine = self.stateMachine else {
            return
        }
        switch event {
            case .pressed:
                stateMachine.enter(OffState.self)
            case .turned:
                if switchController.count < 5 {
                    stateMachine.enter(YellowState.self)
                } else {
                    stateMachine.enter(RedState.self)
                }
        }
    }

}

class YellowState: GKState, SwitchEventProcessor {

    private let switchController: SwitchController

    init(switchController: SwitchController) {
        self.switchController = switchController
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GreenState.Type || stateClass is OffState.Type
    }

    override func didEnter(from previousState: GKState?) {
        print("Light is now YELLOW, was \(String(describing: previousState)) - count: \(switchController.count)")
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

class RedState: GKState, SwitchEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is OffState.Type
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
            default:
                return
        }
    }

}

//
// MARK: - External controllers
//

class SwitchController {
    @Published public var count = 0

    public func incrementCounter() {
        count += 1
    }

    public func resetCounter() {
        count = 0
    }
}

//
// MARK: - StateMachine
//

class LightController {

    private let stateMachine: GKStateMachine

    init(switchController: SwitchController) {
        self.stateMachine = GKStateMachine(states: [
            OffState(switchController: switchController),
            GreenState(switchController: switchController),
            YellowState(switchController: switchController),
            RedState(),
        ]
        )
        stateMachine.enter(OffState.self)
    }

    @Published public var currentState: LightState = .off

    public func turn() {
        process(event: .turned)
    }

    public func press() {
        process(event: .pressed)
    }

    private func process(event: SwitchEvent) {
        guard let state = stateMachine.currentState as? any SwitchEventProcessor else {
            return
        }

        state.process(event: event)

        switch stateMachine.currentState {
            case is OffState:
                currentState = .off
            case is GreenState:
                currentState = .green
            case is YellowState:
                currentState = .yellow
            case is RedState:
                currentState = .red
            default:
                currentState = .off
        }
    }

}

// swiftlint:enable identifier_name
