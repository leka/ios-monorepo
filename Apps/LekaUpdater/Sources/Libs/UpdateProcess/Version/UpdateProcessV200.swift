// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine
import Foundation
import GameplayKit
import RobotKit
import Version

// MARK: - UpdateEvent

// swiftlint:disable file_length

private enum UpdateEvent {
    case startUpdateRequested

    case fileLoaded
    case failedToLoadFile
    case fileExchangeStateSet
    case destinationPathSet
    case fileCleared
    case fileSent
    case fileVerificationReceived
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
        stateClass is StateErrorFailedToLoadFile.Type || stateClass is StateSettingFileExchangeState.Type
            || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from _: GKState?) {
        let isLoaded = globalFirmwareManager.load()

        if isLoaded {
            self.process(event: .fileLoaded)
        } else {
            self.process(event: .failedToLoadFile)
        }
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileLoaded:
                stateMachine?.enter(StateSettingFileExchangeState.self)
            case .failedToLoadFile:
                stateMachine?.enter(StateErrorFailedToLoadFile.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }
}

// MARK: - StateSettingFileExchangeState

private class StateSettingFileExchangeState: GKState, StateEventProcessor {
    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateSettingDestinationPath.Type
            || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from _: GKState?) {
        self.setFileExchangeState()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileExchangeStateSet:
                stateMachine?.enter(StateSettingDestinationPath.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }

    // MARK: Private

    private func setFileExchangeState() {
        let data = Data([1])

        let characteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.setState,
            serviceUUID: BLESpecs.FileExchange.service,
            onWrite: {
                sleep(1)
                self.process(event: .fileExchangeStateSet)
            }
        )

        Robot.shared.connectedPeripheral?.send(data, forCharacteristic: characteristic)
    }
}

// MARK: - StateSettingDestinationPath

private class StateSettingDestinationPath: GKState, StateEventProcessor {
    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateClearingFile.Type || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from _: GKState?) {
        self.setDestinationPath()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .destinationPathSet:
                stateMachine?.enter(StateClearingFile.self)
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

// MARK: - StateClearingFile

private class StateClearingFile: GKState, StateEventProcessor {
    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateSendingFile.Type || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from _: GKState?) {
        self.setClearPath()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .fileCleared:
                stateMachine?.enter(StateSendingFile.self)
            case .robotDisconnected:
                stateMachine?.enter(StateErrorRobotUnexpectedDisconnection.self)
            default:
                return
        }
    }

    // MARK: Private

    private func setClearPath() {
        let data = Data([1])

        let characteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FileExchange.Characteristics.clearFile,
            serviceUUID: BLESpecs.FileExchange.service,
            onWrite: {
                self.process(event: .fileCleared)
            }
        )

        Robot.shared.connectedPeripheral?.send(data, forCharacteristic: characteristic)
    }
}

// MARK: - StateSendingFile

private class StateSendingFile: GKState, StateEventProcessor {
    // MARK: Lifecycle

    override init() {
        self.firmwareDataSize = globalFirmwareManager.data.count

        self.currentPacket = 0

        super.init()

        self.subscribeToFirmwareDataUpdates()
    }

    // MARK: Public

    public var progression = CurrentValueSubject<Float, Never>(0.0)

    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateApplyingUpdate.Type || stateClass is StateErrorRobotUnexpectedDisconnection.Type
    }

    override func didEnter(from _: GKState?) {
        self.maximumPacketSize = Robot.shared.negotiatedMTU.value - self.l2capOverhead
        self.sendFile()
    }

    override func willExit(to _: GKState) {
        self.cancellables.removeAll()
        self.characteristic = nil
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

    private lazy var characteristic: CharacteristicModelWriteOnly? = CharacteristicModelWriteOnly(
        characteristicUUID: BLESpecs.FileExchange.Characteristics.fileReceptionBuffer,
        serviceUUID: BLESpecs.FileExchange.service,
        onWrite: {
            self.currentPacket += 1
            self.tryToSendNextPacket()
        }
    )

    private var firmwareDataSize: Int = 0
    private let l2capOverhead: Int = 3
    private var maximumPacketSize: Int = 182 // 185 (iOS max MTU) - 3 (header size)

    private var currentPacket: Int = 0

    private var expectedCompletePackets: Int {
        Int(floor(Double(self.firmwareDataSize / self.maximumPacketSize)))
    }

    private var expectedRemainingBytes: Int {
        self.firmwareDataSize % self.maximumPacketSize
    }

    private var expectedPackets: Int {
        self.expectedRemainingBytes == 0 ? self.expectedCompletePackets : self.expectedCompletePackets + 1
    }

    private var _progression: Float {
        Float(self.currentPacket) / Float(self.expectedPackets)
    }

    private func subscribeToFirmwareDataUpdates() {
        globalFirmwareManager.$data
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.firmwareDataSize = data.count
            }
            .store(in: &self.cancellables)
    }

    private func sendFile() {
        self.tryToSendNextPacket()
    }

    private func tryToSendNextPacket() {
        self.progression.send(self._progression)
        if self._progression < 1.0 {
            self.sendNextPacket()
        } else {
            self.process(event: .fileSent)
        }
    }

    private func sendNextPacket() {
        let startIndex = self.currentPacket * self.maximumPacketSize
        let endIndex =
            self.currentPacket < self.expectedCompletePackets
                ? startIndex + self.maximumPacketSize - 1 : startIndex + self.expectedRemainingBytes - 1

        let dataToSend = globalFirmwareManager.data[startIndex...endIndex]

        if let characteristic {
            Robot.shared.connectedPeripheral?.send(dataToSend, forCharacteristic: characteristic)
        }
    }
}

// MARK: - StateApplyingUpdate

private class StateApplyingUpdate: GKState, StateEventProcessor {
    // MARK: Internal

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass is StateWaitingForRobotToReboot.Type
    }

    override func didEnter(from _: GKState?) {
        self.setMajor()
    }

    override func willExit(to _: GKState) {
        self.cancellables.removeAll()
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

    private func setMajor() {
        let majorData = Data([globalFirmwareManager.major])

        let majorCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMajor,
            serviceUUID: BLESpecs.FirmwareUpdate.service,
            onWrite: self.setMinor
        )

        Robot.shared.connectedPeripheral?.send(majorData, forCharacteristic: majorCharacteristic)
    }

    private func setMinor() {
        let minorData = Data([globalFirmwareManager.minor])

        let minorCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionMinor,
            serviceUUID: BLESpecs.FirmwareUpdate.service,
            onWrite: self.setRevision
        )

        Robot.shared.connectedPeripheral?.send(minorData, forCharacteristic: minorCharacteristic)
    }

    private func setRevision() {
        let revisionData = globalFirmwareManager.revision.data

        let revisionCharacteristic = CharacteristicModelWriteOnly(
            characteristicUUID: BLESpecs.FirmwareUpdate.Characteristics.versionRevision,
            serviceUUID: BLESpecs.FirmwareUpdate.service,
            onWrite: self.applyUpdate
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

    override func didEnter(from _: GKState?) {
        self.registerScanForRobot()
    }

    override func willExit(to _: GKState) {
        self.cancellables.removeAll()
    }

    func process(event: UpdateEvent) {
        switch event {
            case .robotDetected:
                if self.isRobotUpToDate {
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
            .store(in: &self.cancellables)
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

// MARK: - UpdateProcessV200

class UpdateProcessV200: UpdateProcessProtocol {
    // MARK: Lifecycle

    init() {
        self.stateMachine = GKStateMachine(states: [
            StateInitial(),

            StateLoadingUpdateFile(),
            StateSettingFileExchangeState(),
            StateSettingDestinationPath(),
            StateClearingFile(),
            self.stateSendingFile,
            StateApplyingUpdate(),
            StateWaitingForRobotToReboot(expectedRobot: Robot.shared.connectedPeripheral),

            StateFinal(),

            StateErrorFailedToLoadFile(),
            StateErrorRobotNotUpToDate(),
            StateErrorRobotUnexpectedDisconnection(),
        ])
        self.stateMachine?.enter(StateInitial.self)

        self.startRoutineToUpdateCurrentState()
        self.registerDidDisconnect()
        self.sendingFileProgression = self.stateSendingFile.progression
    }

    // MARK: Public

    // MARK: - Public variables

    public var currentStage = CurrentValueSubject<UpdateProcessStage, UpdateProcessError>(.initial)
    public var sendingFileProgression = CurrentValueSubject<Float, Never>(0.0)

    public func startProcess() {
        self.process(event: .startUpdateRequested)
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

        self.updateCurrentState()
    }

    private func registerDidDisconnect() {
        BLEManager.shared.didDisconnect
            .receive(on: DispatchQueue.main)
            .sink {
                self.process(event: .robotDisconnected)
            }
            .store(in: &self.cancellables)
    }

    private func startRoutineToUpdateCurrentState() {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                self.updateCurrentState()
            }
            .store(in: &self.cancellables)
    }

    private func updateCurrentState() {
        guard let state = stateMachine?.currentState else { return }

        switch state {
            case is StateInitial:
                self.currentStage.send(.initial)
            case is StateLoadingUpdateFile,
                 is StateSettingFileExchangeState,
                 is StateSettingDestinationPath,
                 is StateClearingFile,
                 is StateSendingFile:
                self.currentStage.send(.sendingUpdate)
            case is StateApplyingUpdate,
                 is StateWaitingForRobotToReboot:
                self.currentStage.send(.installingUpdate)
            case is StateFinal:
                self.currentStage.send(completion: .finished)
            case is any StateError:
                self.sendError(state: state)
            default:
                self.currentStage.send(completion: .failure(.unknown))
        }
    }

    private func sendError(state: GKState) {
        switch state {
            case is StateErrorFailedToLoadFile:
                self.currentStage.send(completion: .failure(.failedToLoadFile))
            case is StateErrorRobotNotUpToDate:
                self.currentStage.send(completion: .failure(.robotNotUpToDate))
            case is StateErrorRobotUnexpectedDisconnection:
                self.currentStage.send(completion: .failure(.robotUnexpectedDisconnection))
            default:
                self.currentStage.send(completion: .failure(.unknown))
        }
    }
}

// swiftlint:enable file_length
