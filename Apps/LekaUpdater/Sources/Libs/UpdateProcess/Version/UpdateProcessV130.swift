// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation
import GameplayKit

// MARK: - events

private enum UpdateEvent {
    case startUpdateRequested

    case fileLoaded, failedToLoadFile
    case fileExchangeStateSet
    case destinationPathSet
    case fileCleared
    case fileSent
    case robotDisconnected
    case robotDetected
}

// MARK: - StateMachine states

private protocol StateEventProcessor {
    func process(event: UpdateEvent)
}

private class StateInitial: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateLoadingUpdateFile.Type
    }

    func process(event: UpdateEvent) {
        switch event {
            case .startUpdateRequested:
                self.stateMachine?.enter(StateLoadingUpdateFile.self)
            default:
                return
        }
    }
}

private class StateLoadingUpdateFile: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateErrorFailedToLoadFile.Type || stateClass is StateSettingFileExchangeState.Type
    }

    override func didEnter(from previousState: GKState?) {

        let isLoaded = globalFirmwareManager.load()

        if isLoaded {
            process(event: .fileLoaded)
        } else {
            process(event: .failedToLoadFile)
        }
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileLoaded:
                self.stateMachine?.enter(StateSettingFileExchangeState.self)
            case .failedToLoadFile:
                self.stateMachine?.enter(StateErrorFailedToLoadFile.self)
            default:
                return
        }
    }
}

private class StateSettingFileExchangeState: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateSettingDestinationPath.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: setFileExchangeState)
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileExchangeStateSet:
                self.stateMachine?.enter(StateSettingDestinationPath.self)
            default:
                return
        }
    }

    private func setFileExchangeState() {
        let data = Data([1])

        var characteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.setState,
            serviceUUID: BLESpecs.FileExchange.service
        )

        characteristic.onWrite = {
            self.process(event: .fileExchangeStateSet)
        }

        globalRobotManager.robotPeripheral?.send(data, forCharacteristic: characteristic)
    }
}

private class StateSettingDestinationPath: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateClearingFile.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: setDestinationPath)
    }

    func process(event: UpdateEvent) {
        switch event {
            case .destinationPathSet:
                self.stateMachine?.enter(StateClearingFile.self)
            default:
                return
        }
    }

    private func setDestinationPath() {
        let osVersion = globalFirmwareManager.currentVersion

        let directory = "/fs/usr/os"
        let filename = "LekaOS-\(osVersion).bin"
        let destinationPath = directory + "/" + filename

        var characteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.filePath,
            serviceUUID: BLESpecs.FileExchange.service
        )

        characteristic.onWrite = {
            self.process(event: .destinationPathSet)
        }

        globalRobotManager.robotPeripheral?.send(destinationPath.data(using: .utf8)!, forCharacteristic: characteristic)
    }
}

private class StateClearingFile: GKState, StateEventProcessor {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateSendingFile.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: setClearPath)
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileCleared:
                self.stateMachine?.enter(StateSendingFile.self)
            default:
                return
        }
    }

    private func setClearPath() {
        let data = Data([1])

        var characteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.clearFile,
            serviceUUID: BLESpecs.FileExchange.service
        )

        characteristic.onWrite = {
            self.process(event: .fileCleared)
        }

        globalRobotManager.robotPeripheral?.send(data, forCharacteristic: characteristic)
    }
}

private class StateSendingFile: GKState, StateEventProcessor {

    private var cancellables: Set<AnyCancellable> = []

    private let maximumPacketSize: Int = 61

    private var currentPacket: Int = 0
    private var expectedCompletePackets: Int
    private var expectedRemainingBytes: Int
    private var expectedPackets: Int {
        expectedRemainingBytes == 0 ? expectedCompletePackets : expectedCompletePackets + 1
    }
    private var _progression: Float {
        Float(currentPacket) / Float(expectedPackets)
    }

    private var characteristic = WriteOnlyCharacteristic(
        characteristicUUID: BLESpecs.FileExchange.Characteristics.fileReceptionBuffer,
        serviceUUID: BLESpecs.FileExchange.service
    )

    public var progression = CurrentValueSubject<Float, Never>(0.0)

    override init() {
        let dataSize = globalFirmwareManager.data.count

        self.expectedCompletePackets = Int(floor(Double(dataSize / maximumPacketSize)))
        self.expectedRemainingBytes = Int(dataSize % maximumPacketSize)

        self.currentPacket = 0

        super.init()

        self.subscribeToFirmwareDataUpdates()
    }

    private func subscribeToFirmwareDataUpdates() {
        globalFirmwareManager.$data
            .receive(on: DispatchQueue.main)
            .sink { data in
                let dataSize = data.count

                self.expectedCompletePackets = Int(floor(Double(dataSize / self.maximumPacketSize)))
                self.expectedRemainingBytes = Int(dataSize % self.maximumPacketSize)
            }
            .store(in: &cancellables)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateApplyingUpdate.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: sendFile)
    }

    override func willExit(to nextState: GKState) {
        cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileSent:
                self.stateMachine?.enter(StateApplyingUpdate.self)
            default:
                return
        }
    }

    private func sendFile() {
        characteristic.onWrite = {
            self.currentPacket += 1
            self.tryToSendNextPacket()
        }

        tryToSendNextPacket()
    }

    private func tryToSendNextPacket() {
        progression.send(_progression)
        if _progression < 1.0 {
            sendNextPacket()
        } else {
            process(event: .fileSent)
        }
    }

    private func sendNextPacket() {
        let startIndex = currentPacket * maximumPacketSize
        let endIndex =
            currentPacket < expectedCompletePackets
            ? startIndex + maximumPacketSize - 1 : startIndex + expectedRemainingBytes - 1

        let dataToSend = globalFirmwareManager.data[startIndex...endIndex]

        globalRobotManager.robotPeripheral?.send(dataToSend, forCharacteristic: characteristic)
    }
}

private class StateApplyingUpdate: GKState, StateEventProcessor {

    private var cancellables: Set<AnyCancellable> = []

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateWaitingForRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        registerDidDisconnect()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: setMajorMinorRevision)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: applyUpdate)

    }

    override func willExit(to nextState: GKState) {
        cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .robotDisconnected:
                self.stateMachine?.enter(StateWaitingForRobotToReboot.self)
            default:
                return
        }
    }

    private func registerDidDisconnect() {
        globalBleManager.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink {
                self.process(event: .robotDisconnected)
            }
            .store(in: &cancellables)
    }

    private func setMajorMinorRevision() {
        let majorData = Data([globalFirmwareManager.major])

        let majorCharacteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMajor,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        globalRobotManager.robotPeripheral?.send(majorData, forCharacteristic: majorCharacteristic)

        let minorData = Data([globalFirmwareManager.minor])

        let minorCharacteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMinor,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        globalRobotManager.robotPeripheral?.send(minorData, forCharacteristic: minorCharacteristic)

        let revisionData = globalFirmwareManager.revision.data

        let revisionCharacteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionRevision,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        globalRobotManager.robotPeripheral?.send(revisionData, forCharacteristic: revisionCharacteristic)
    }

    private func applyUpdate() {
        let applyValue = Data([1])

        let characteristic = WriteOnlyCharacteristic(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.requestUpdate,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        globalRobotManager.robotPeripheral?.send(applyValue, forCharacteristic: characteristic)
    }
}

private class StateWaitingForRobotToReboot: GKState, StateEventProcessor {

    private var cancellables: Set<AnyCancellable> = []

    private var isRobotUpToDate: Bool = false
    private var isReconnected = PassthroughSubject<Void, Never>()

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is StateFinal.Type || stateClass is StateErrorRobotNotUpToDate.Type
    }

    override func didEnter(from previousState: GKState?) {
        registerScanForRobot()
        registerIsReconnected()
    }

    override func willExit(to nextState: GKState) {
        cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .robotDetected:
                if isRobotUpToDate {
                    self.stateMachine?.enter(StateFinal.self)
                } else {
                    self.stateMachine?.enter(StateErrorRobotNotUpToDate.self)
                }
            default:
                return
        }
    }

    private func registerScanForRobot() {
        globalBleManager.scanForRobots()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { robotDiscoveryList in
                    let robotDetected = robotDiscoveryList.first { robotDiscovery in
                        robotDiscovery.robotPeripheral == globalRobotManager.robotPeripheral
                    }
                    if let robotDetected = robotDetected {
                        self.isRobotUpToDate =
                            robotDetected.advertisingData.osVersion == globalFirmwareManager.currentVersion

                        self.reconnect(to: robotDetected)
                    }
                }
            )
            .store(in: &cancellables)
    }

    private func reconnect(to robot: RobotDiscovery) {
        globalBleManager.connect(robot)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    globalRobotManager.setRobotPeripheral(from: robot)
                    self.isReconnected.send()
                },
                receiveValue: { _ in
                    // do nothing
                }
            )
            .store(in: &cancellables)
    }

    private func registerIsReconnected() {
        self.isReconnected
            .receive(on: DispatchQueue.main)
            .sink {
                self.process(event: .robotDetected)
            }
            .store(in: &cancellables)
    }
}

private class StateFinal: GKState {}

// MARK: - StateMachine error states

private protocol StateError {}

private class StateErrorFailedToLoadFile: GKState, StateError {}
private class StateErrorFailedToVerifyFile: GKState, StateError {}
private class StateErrorRobotNotUpToDate: GKState, StateError {}

// MARK: - StateMachine

class UpdateProcessV130: UpdateProcessProtocol {

    // MARK: - Private variables

    private var stateMachine: GKStateMachine?
    private var stateSendingFile = StateSendingFile()

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public variables

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)
    public var sendingFileProgression = CurrentValueSubject<Float, Never>(0.0)

    init() {
        self.stateMachine = GKStateMachine(states: [
            StateInitial(),

            StateLoadingUpdateFile(),
            StateSettingFileExchangeState(),
            StateSettingDestinationPath(),
            StateClearingFile(),
            stateSendingFile,
            StateApplyingUpdate(),
            StateWaitingForRobotToReboot(),

            StateFinal(),

            StateErrorFailedToLoadFile(),
            StateErrorRobotNotUpToDate(),
        ])
        self.stateMachine?.enter(StateInitial.self)

        self.startRoutineToUpdateCurrentState()
        self.sendingFileProgression = self.stateSendingFile.progression
    }

    public func startProcess() {
        process(event: .startUpdateRequested)
    }

    private func process(event: UpdateEvent) {
        guard let state = stateMachine?.currentState as? any StateEventProcessor else {
            return
        }

        state.process(event: event)

        updateCurrentState()
    }

    private func startRoutineToUpdateCurrentState() {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                self.updateCurrentState()
            }
            .store(in: &cancellables)
    }

    private func updateCurrentState() {
        guard let state = stateMachine?.currentState else { return }

        switch state {
            case is StateInitial:
                currentStage.send(.initial)
            case is StateLoadingUpdateFile, is StateSettingFileExchangeState, is StateSettingDestinationPath,
                is StateClearingFile,
                is StateSendingFile:
                currentStage.send(.sendingUpdate)
            case is StateApplyingUpdate, is StateWaitingForRobotToReboot:
                currentStage.send(.installingUpdate)
            case is StateFinal:
                currentStage.send(completion: .finished)
            case is any StateError:
                sendError(state: state)
            default:
                currentStage.send(completion: .failure(.unknown))
        }
    }

    private func sendError(state: GKState) {
        switch state {
            case is StateErrorFailedToLoadFile:
                currentStage.send(completion: .failure(.failedToLoadFile))
            case is StateErrorFailedToVerifyFile:
                currentStage.send(completion: .failure(.failedToVerifyFile))
            case is StateErrorRobotNotUpToDate:
                currentStage.send(completion: .failure(.robotNotUpToDate))
            default:
                currentStage.send(completion: .failure(.unknown))
        }
    }

}
