// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation
import GameplayKit

private protocol StateEventProcessor {
    func process(event: UpdateProcessEvent)
}

private protocol ErrorState {}

//
// MARK: - States
//

private class InitialState: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LoadingUpdateFileState.Type
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .startUpdateRequested:
                self.stateMachine?.enter(LoadingUpdateFileState.self)
            default:
                return
        }
    }
}

private class LoadingUpdateFileState: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ErrorFailedToLoadFile.Type || stateClass is SettingDestinationPathState.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.loadUpdateFile()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .fileLoaded:
                self.stateMachine?.enter(SettingDestinationPathState.self)
            case .failedToLoadFile:
                self.stateMachine?.enter(ErrorFailedToLoadFile.self)
            default:
                return
        }
    }
}

private class SettingDestinationPathState: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SendingFileState.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.setBLEDestinationPathAndClearFile()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .destinationPathSet:
                self.stateMachine?.enter(SendingFileState.self)
            default:
                return
        }
    }
}

private class SendingFileState: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is ApplyingUpdate.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.sendFile()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .fileSent:
                self.stateMachine?.enter(ApplyingUpdate.self)
            default:
                return
        }
    }
}

private class ApplyingUpdate: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        controller.setBLEMajorMinorRevisionApply()
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .robotDisconnected:
                self.stateMachine?.enter(WaitingRobotToReboot.self)
            default:
                return
        }
    }
}

private class WaitingRobotToReboot: GKState, StateEventProcessor {

    private let controller: Controller

    init(controller: Controller) {
        self.controller = controller
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is FinalState.Type || stateClass is ErrorRobotNotUpToDate.Type
    }

    func process(event: UpdateProcessEvent) {
        switch event {
            case .robotDetected:
                if controller.isRobotUpToDate() {
                    self.stateMachine?.enter(FinalState.self)
                } else {
                    self.stateMachine?.enter(ErrorRobotNotUpToDate.self)
                }
            default:
                return
        }
    }
}

private class FinalState: GKState {}

private class ErrorFailedToLoadFile: GKState, ErrorState {}
private class ErrorRobotNotUpToDate: GKState, ErrorState {}

//
// MARK: Controller
//

private class Controller {
    let robot: DummyRobotModel

    public var event = PassthroughSubject<UpdateProcessEvent, Error>()

    init(robot: DummyRobotModel) {
        self.robot = robot
        self.event = robot.event
    }

    fileprivate func loadUpdateFile() {
        print("Loading update file...")

        Task {
            try await Task<Never, Never>.sleep(seconds: 1)
            event.send(.fileLoaded)
        }  // TODO: Remove for debug purpose
        // TODO: Implement loadUpdateFile
    }

    fileprivate func setBLEDestinationPathAndClearFile() {
        print("Setting BLE Destination Path and Clear File...")

        Task {
            try await Task<Never, Never>.sleep(seconds: 0.1)
            event.send(.destinationPathSet)
        }  // TODO: Remove for debug purpose
        // TODO: Implement setBLEDestinationPathAndClearFile
    }

    fileprivate func sendFile() {
        print("Sending file...")

        Task {
            try await Task<Never, Never>.sleep(seconds: 10)
            event.send(.fileSent)
        }  // TODO: Remove for debug purpose
        // TODO: Implement sendFile
    }

    fileprivate func setBLEMajorMinorRevisionApply() {
        print("Setting BLE Major Minor Revision Apply...")
        // TODO: Implement setBLEMajorMinorRevisionApply
    }

    fileprivate func isRobotUpToDate() -> Bool {
        // TODO: Implement isRobotUpToDate
        return false
    }
}

//
// MARK: - StateMachine
//

class UpdateProcessV100: UpdateProcessProtocol {
    private var stateMachine: GKStateMachine?
    private var cancellables: Set<AnyCancellable> = []

    public var currentState = CurrentValueSubject<UpdateProcessState, UpdateProcessError>(.initial)
    public var userState = CurrentValueSubject<UpdateStatusState, UpdateStatusError>(.initial)

    init(robot: DummyRobotModel) {
        let controller = Controller(robot: robot)
        controller.event
            .receive(on: DispatchQueue.main)
            .sink { _ in
                // nothing to do
            } receiveValue: { event in
                self.raiseEvent(event: event)
            }
            .store(in: &cancellables)

        self.stateMachine = GKStateMachine(states: [
            InitialState(),

            LoadingUpdateFileState(
                controller: controller),
            SettingDestinationPathState(controller: controller),
            SendingFileState(controller: controller),
            ApplyingUpdate(controller: controller),
            WaitingRobotToReboot(
                controller: controller),

            ErrorFailedToLoadFile(),
            ErrorRobotNotUpToDate(),

            FinalState(),
        ])
        self.stateMachine?.enter(InitialState.self)

        subscribeToStateUpdate()
    }

    public func startUpdate() {
        process(event: .startUpdateRequested)
    }

    public func raiseEvent(event: UpdateProcessEvent) {
        process(event: event)
    }

    private func process(event: UpdateProcessEvent) {
        guard let state = stateMachine?.currentState as? any StateEventProcessor else {
            return
        }

        state.process(event: event)

        updateCurrentState()
    }

    private func updateCurrentState() {
        guard let state = stateMachine?.currentState else { return }

        switch state {
            case is InitialState:
                currentState.send(.initial)
            case is LoadingUpdateFileState:
                currentState.send(.loadingUpdateFile)
            case is SettingDestinationPathState:
                currentState.send(.settingDestinationPathAndClearFile)
            case is SendingFileState:
                currentState.send(.sendingFile)
            case is ApplyingUpdate:
                currentState.send(.applyingUpdate)
            case is WaitingRobotToReboot:
                currentState.send(.waitingRobotToReboot)
            case is FinalState:
                currentState.send(completion: .finished)
            case is any ErrorState:
                sendError(state: state)
            default:
                currentState.send(completion: .failure(.unknown))
        }
    }

    private func sendError(state: GKState) {
        switch state {
            case is ErrorFailedToLoadFile:
                currentState.send(completion: .failure(.failedToLoadFile))
            case is ErrorRobotNotUpToDate:
                currentState.send(completion: .failure(.robotNotUpToDate))
            default:
                currentState.send(completion: .failure(.unknown))
        }
    }

    private func subscribeToStateUpdate() {
        self.currentState
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: self.convertCompletion, receiveValue: self.convertReceivedValue)
            .store(in: &cancellables)
    }

    private func convertCompletion(completion: Subscribers.Completion<UpdateProcessError>) {
        switch completion {
            case .finished:
                self.userState.send(completion: .finished)
            case .failure(let error):
                var result: UpdateStatusError = .unknown
                switch error {
                    case .failedToLoadFile:
                        result = .failedToLoadFile
                    case .robotNotUpToDate:
                        result = .robotNotUpToDate
                    case .notAvailable:
                        result = .updateProcessNotAvailable
                    default:
                        result = .unknown
                }
                self.userState.send(completion: .failure(result))
        }
    }

    private func convertReceivedValue(state: UpdateProcessState) {
        var result: UpdateStatusState = .initial
        switch state {
            case .initial:
                result = .initial
            case .loadingUpdateFile, .settingDestinationPathAndClearFile, .sendingFile:
                result = .sendingUpdate
            case .applyingUpdate, .waitingRobotToReboot:
                result = .installingUpdate
        }
        self.userState.send(result)
    }

}
