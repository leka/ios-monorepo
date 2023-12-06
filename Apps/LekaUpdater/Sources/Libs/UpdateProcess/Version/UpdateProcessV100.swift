// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation
import GameplayKit
import RobotKit
import Version

// MARK: - UpdateEvent

private enum UpdateEvent {
    case startUpdateRequested

    case fileLoaded, failedToLoadFile
    case destinationPathSet
    case fileSent
    case robotDisconnected
    case robotDetected
}

// MARK: - StateEventProcessor

private protocol StateEventProcessor {
    func process(event: UpdateEvent)
}

// MARK: - StateInitial

private class StateInitial: GKState, StateEventProcessor {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateLoadingUpdateFile.Type || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    func process(event: UpdateEvent) {
        switch event {
            case .startUpdateRequested:
                stateMachine?.enter(StateLoadingUpdateFile.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }
}

// MARK: - StateLoadingUpdateFile

private class StateLoadingUpdateFile: GKState, StateEventProcessor {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateErrorFailedToLoadFile.Type || stateClass is StateSettingDestinationPath.Type
            || stateClass is StateErrorRobotUnexpectedDisconnection.Type
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
                stateMachine?.enter(StateSettingDestinationPath.self)
            case .failedToLoadFile:
                stateMachine?.enter(StateErrorFailedToLoadFile.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }
}

// MARK: - StateSettingDestinationPath

private class StateSettingDestinationPath: GKState, StateEventProcessor {
    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateSendingFile.Type || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: setDestinationPath)
    }

    func process(event: UpdateEvent) {
        switch event {
            case .destinationPathSet:
                stateMachine?.enter(StateSendingFile.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }

    // MARK: Private

    private func setDestinationPath() {
        let osVersion = globalFirmwareManager.currentVersion

        let directory = "/fs/usr/os"
        let filename = "LekaOS-\(osVersion).bin"
        let destinationPath = directory + "/" + filename

        let characteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.filePath,
            serviceUUID: BLESpecs.FileExchange.service,
            onWrite: {
                self.process(event: .destinationPathSet)
            }
        )

        Robot.shared.connectedPeripheral?.send(destinationPath.data(using: .utf8)!, forCharacteristic: characteristic)
    }
}

// MARK: - StateSendingFile

private class StateSendingFile: GKState, StateEventProcessor {
    // MARK: Lifecycle

    override init() {
        let dataSize = globalFirmwareManager.data.count

        self.expectedCompletePackets = Int(floor(Double(dataSize / maximumPacketSize)))
        self.expectedRemainingBytes = Int(dataSize % maximumPacketSize)

        self.currentPacket = 0

        super.init()

        subscribeToFirmwareDataUpdates()
    }

    // MARK: Public

    public var progression = CurrentValueSubject<Float, Never>(0.0)

    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateApplyingUpdate.Type || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: sendFile)
    }

    override func willExit(to nextState: GKState) {
        cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileSent:
                stateMachine?.enter(StateApplyingUpdate.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

    private let maximumPacketSize: Int = 61

    private var currentPacket: Int = 0
    private var expectedCompletePackets: Int
    private var expectedRemainingBytes: Int
    private lazy var characteristic: CharacteristicModelWriteOnly = CharacteristicModelWriteOnly(
        characteristicUUID: BLESpecs.FileExchange.Characteristics.fileReceptionBuffer,
        serviceUUID: BLESpecs.FileExchange.service,
        onWrite: {
            self.currentPacket += 1
            self.tryToSendNextPacket()
        }
    )

    private var expectedPackets: Int {
        expectedRemainingBytes == 0 ? expectedCompletePackets : expectedCompletePackets + 1
    }

    private var _progression: Float {
        Float(currentPacket) / Float(expectedPackets)
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

    private func sendFile() {
        tryToSendNextPacket()
    }

    private func tryToSendNextPacket() {
        if isInCriticalSection() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: tryToSendNextPacket)
            return
        }

        progression.send(_progression)
        if _progression < 1.0 {
            sendNextPacket()
        } else {
            process(event: .fileSent)
        }
    }

    private func isInCriticalSection() -> Bool {
        let isNotCharging = !Robot.shared.isCharging.value

        let battery = Robot.shared.battery.value
        let isNearBatteryLevelChange =
            23...27 ~= battery || 48...52 ~= battery || 73...77 ~= battery || 88...92 ~= battery

        return isNotCharging || isNearBatteryLevelChange
    }

    private func sendNextPacket() {
        let startIndex = currentPacket * maximumPacketSize
        let endIndex =
            currentPacket < expectedCompletePackets
                ? startIndex + maximumPacketSize - 1 : startIndex + expectedRemainingBytes - 1

        let dataToSend = globalFirmwareManager.data[startIndex...endIndex]

        Robot.shared.connectedPeripheral?.send(dataToSend, forCharacteristic: characteristic)
    }
}

// MARK: - StateApplyingUpdate

private class StateApplyingUpdate: GKState, StateEventProcessor {
    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateWaitingForRobotToReboot.Type
    }

    override func didEnter(from previousState: GKState?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: setMajorMinorRevision)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: applyUpdate)
    }

    override func willExit(to nextState: GKState) {
        cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .robotDisconnected:
                stateMachine?.enter(StateWaitingForRobotToReboot.self)
            default:
                return
        }
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

    private func setMajorMinorRevision() {
        let majorData = Data([globalFirmwareManager.major])

        let majorCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMajor,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        Robot.shared.connectedPeripheral?.send(majorData, forCharacteristic: majorCharacteristic)

        let minorData = Data([globalFirmwareManager.minor])

        let minorCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMinor,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        Robot.shared.connectedPeripheral?.send(minorData, forCharacteristic: minorCharacteristic)

        let revisionData = globalFirmwareManager.revision.data

        let revisionCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionRevision,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        Robot.shared.connectedPeripheral?.send(revisionData, forCharacteristic: revisionCharacteristic)
    }

    private func applyUpdate() {
        let applyValue = Data([1])

        let characteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.requestUpdate,
            serviceUUID: BLESpecs.FirmwareUpdate.service
        )

        Robot.shared.connectedPeripheral?.send(applyValue, forCharacteristic: characteristic)
    }
}

// MARK: - StateWaitingForRobotToReboot

private class StateWaitingForRobotToReboot: GKState, StateEventProcessor {
    // MARK: Lifecycle

    init(expectedRobot: RobotPeripheral?) {
        self.expectedRobot = expectedRobot
    }

    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateFinal.Type || stateClass is StateErrorRobotNotUpToDate.Type
            || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from previousState: GKState?) {
        registerScanForRobot()
    }

    override func willExit(to nextState: GKState) {
        cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .robotDetected:
                if isRobotUpToDate {
                    stateMachine?.enter(StateFinal.self)
                } else {
                    stateMachine?.enter(StateErrorRobotNotUpToDate.self)
                }
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

    private var expectedRobot: RobotPeripheral?
    private var isRobotUpToDate: Bool = false

    private func registerScanForRobot() {
        BLEManager.shared.scanForRobots()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { robotDiscoveryList in
                    let robotDetected = robotDiscoveryList.first { robotDiscovery in
                        robotDiscovery.robotPeripheral == self.expectedRobot
                    }
                    if let robotDetected {
                        self.isRobotUpToDate =
                            Version(robotDetected.osVersion) == globalFirmwareManager.currentVersion

                        self.process(event: .robotDetected)
                    }
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - StateFinal

private class StateFinal: GKState {}

// MARK: - StateError

private protocol StateError {}

// MARK: - StateErrorFailedToLoadFile

private class StateErrorFailedToLoadFile: GKState, StateError {}

// MARK: - StateErrorRobotNotUpToDate

private class StateErrorRobotNotUpToDate: GKState, StateError {}

// MARK: - StateErrorRobotUnexpectedDisconnection

private class StateErrorRobotUnexpectedDisconnection: GKState, StateError {}

// MARK: - UpdateProcessV100

class UpdateProcessV100: UpdateProcessProtocol {
    // MARK: Lifecycle

    init() {
        self.stateMachine = GKStateMachine(states: [
            StateInitial(),

            StateLoadingUpdateFile(),
            stateSendingFile,
            StateApplyingUpdate(),
            StateWaitingForRobotToReboot(expectedRobot: Robot.shared.connectedPeripheral),
            StateSettingDestinationPath(),

            StateFinal(),

            StateErrorFailedToLoadFile(),
            StateErrorRobotNotUpToDate(),
            StateErrorRobotUnexpectedDisconnection(),
        ])
        stateMachine?.enter(StateInitial.self)

        startRoutineToUpdateCurrentState()
        registerDidDisconnect()
        self.sendingFileProgression = stateSendingFile.progression
    }

    // MARK: Public

    // MARK: - Public variables

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)
    public var sendingFileProgression = CurrentValueSubject<Float, Never>(0.0)

    public func startProcess() {
        process(event: .startUpdateRequested)
    }

    // MARK: Private

    // MARK: - Private variables

    private var stateMachine: GKStateMachine?
    private var stateSendingFile = StateSendingFile()

    private var cancellables: Set<AnyCancellable> = []

    private func process(event: UpdateEvent) {
        guard let state = stateMachine?.currentState as? any StateEventProcessor else {
            return
        }

        state.process(event: event)

        updateCurrentState()
    }

    private func registerDidDisconnect() {
        BLEManager.shared.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink {
                self.process(event: .robotDisconnected)
            }
            .store(in: &cancellables)
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
            case is StateLoadingUpdateFile, is StateSettingDestinationPath, is StateSendingFile:
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
            case is StateErrorRobotNotUpToDate:
                currentStage.send(completion: .failure(.robotNotUpToDate))
            case is StateErrorRobotUnexpectedDisconnection:
                currentStage.send(completion: .failure(.robotUnexpectedDisconnection))
            default:
                currentStage.send(completion: .failure(.unknown))
        }
    }
}
