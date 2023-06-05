//
//  Leka_1_0_0SM.swift
//  LekaUpdater
//
//  Created by Yann LOCATELLI on 05/06/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import Actomaton
import Foundation

//
// MARK: - States, events
//

enum Leka_1_0_0_State: Sendable {
    case initial

    case loadingUpdateFile
    case settingDestinationPath
    case sendingFile
    case applyingUpdate
    case waitingRobotToReboot

    case final
}

enum Leka_1_0_0_Event: Sendable {
    case startUpdateRequested

    case fileLoaded, failedToLoadFile
    case destinationPathSet
    case fileSent
    case robotDisconnected
    case robotDetected
}

//
// MARK: - External controllers
//

protocol Leka_1_0_0_RobotController {
    func loadUpdateFile()
    func setBLEDestinationPath()
    func sendFile()
    func setBLEMajorMinorRevisionApply()
}

//
// MARK: - StateMachine
//

class Leka_1_0_0_Controller {
    var stateMachine: Actomaton<Leka_1_0_0_Event, Leka_1_0_0_State>

    @Published public var currentState: Leka_1_0_0_State = .initial

    init(robotController: Leka_1_0_0_RobotController) {
        let reducer = Reducer<Leka_1_0_0_Event, Leka_1_0_0_State, Void>({ event, state, _ in
            switch (state, event) {
                case (.initial, .startUpdateRequested):
                    state = .loadingUpdateFile
                    robotController.loadUpdateFile()
                case (.loadingUpdateFile, .fileLoaded):
                    state = .settingDestinationPath
                    robotController.setBLEDestinationPath()
                case (.loadingUpdateFile, .failedToLoadFile):
                    state = .final
                case (.settingDestinationPath, .destinationPathSet):
                    state = .sendingFile
                    robotController.sendFile()
                case (.sendingFile, .fileSent):
                    state = .applyingUpdate
                    robotController.setBLEMajorMinorRevisionApply()
                case (.applyingUpdate, .robotDisconnected):
                    state = .waitingRobotToReboot
                case (.waitingRobotToReboot, .robotDetected):
                    state = .final
                default:
                    print("nothing")
            }
            return .empty
        })

        self.stateMachine = Actomaton<Leka_1_0_0_Event, Leka_1_0_0_State>(
            state: .initial,
            reducer: reducer
        )
    }

    public func startUpdate() {
        process(event: .startUpdateRequested)
    }

    public func raiseEvent(event: Leka_1_0_0_Event) {
        process(event: event)
    }

    private func process(event: Leka_1_0_0_Event) {
        Task {
            await stateMachine.send(event)
            updateCurrentState()
        }
    }

    private func updateCurrentState() {
        Task {
            currentState = await stateMachine.state
        }
    }
}
