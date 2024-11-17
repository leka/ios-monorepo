// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

// MARK: - BLEManager

public class BLEManager {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(centralManager: CentralManager) {
        self.centralManager = centralManager

        self.subscribeToDidDisconnect()
        self.subscribeToDidConnect()
        self.subscribeToDidUpdateState()
    }

    // MARK: Public

    public enum BLEManagerError: Error {
        case notPoweredOn
    }

    #if targetEnvironment(simulator)
        public static var shared: BLEManager = .init(centralManager: .live())
    #else
        public static var shared: BLEManager = .init(
            centralManager: .live(
                ManagerCreationOptions(showPowerAlert: true, restoreIdentifier: "io.leka.module.BLEKit.Manager.live"))
        )
    #endif

    // MARK: - @Published variables

    public let state = CurrentValueSubject<CBManagerState, Never>(.unknown)
    public let didConnect = PassthroughSubject<RobotPeripheral, Never>()
    public let didDisconnect = PassthroughSubject<Void, Never>()

    public var isConnected: Bool {
        self.connectedRobotPeripheral != nil ? true : false
    }

    public static func live() -> BLEManager {
        BLEManager(centralManager: CentralManager.live())
    }

    public func scanForRobots() -> AnyPublisher<[RobotDiscoveryModel], Error> {
        guard self.centralManager.state == .poweredOn else {
            return Fail(error: BLEManagerError.notPoweredOn).eraseToAnyPublisher()
        }

        return self.centralManager.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])
            .tryScan(
                [],
                { list, discovery -> [PeripheralDiscovery] in
                    guard let index = list.firstIndex(where: {
                        $0.id == discovery.id
                    })
                    else {
                        return list + [discovery]
                    }
                    var newList = list
                    newList[index] = discovery
                    return newList
                }
            )
            .compactMap { peripheralDiscoveries in
                peripheralDiscoveries.compactMap { peripheralDiscovery -> RobotDiscoveryModel? in
                    guard let robotAdvertisingData = RobotAdvertisingData(
                        advertisementData: peripheralDiscovery.advertisementData),
                        let rssi = peripheralDiscovery.rssi
                    else {
                        return nil
                    }

                    let robotPeripheral = RobotPeripheral(peripheral: peripheralDiscovery.peripheral)

                    return RobotDiscoveryModel(
                        robotPeripheral: robotPeripheral, advertisingData: robotAdvertisingData, rssi: rssi
                    )
                }
            }
            .eraseToAnyPublisher()
    }

    public func connect(_ discovery: RobotDiscoveryModel) -> AnyPublisher<RobotPeripheral, Error> {
        guard self.centralManager.state == .poweredOn else {
            return Fail(error: BLEManagerError.notPoweredOn).eraseToAnyPublisher()
        }

        return self.centralManager.connect(discovery.robotPeripheral.peripheral)
            .compactMap { peripheral in
                self.connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
                return self.connectedRobotPeripheral
            }
            .eraseToAnyPublisher()
    }

    public func disconnect() {
        guard let connectedPeripheral = connectedRobotPeripheral?.peripheral else { return }

        self.connectedRobotPeripheral = nil

        if self.centralManager.state == .poweredOn {
            self.centralManager.cancelPeripheralConnection(connectedPeripheral)
        }
    }

    public func retrieveConnectedRobots() -> [RobotPeripheral] {
        guard self.centralManager.state == .poweredOn else {
            return []
        }

        let connectedPeripherals = self.centralManager.retrieveConnectedPeripherals(withServices: [BLESpecs.AdvertisingData.service])

        guard connectedPeripherals.isEmpty == false else {
            return []
        }

        self.connectedRobotPeripheral = RobotPeripheral(peripheral: connectedPeripherals[0])
        self.didConnect.send(self.connectedRobotPeripheral!)

        return connectedPeripherals.map { RobotPeripheral(peripheral: $0) }
    }

    // MARK: Private

    // MARK: - Private variables

    private var centralManager: CentralManager
    private var connectedRobotPeripheral: RobotPeripheral?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Private functions

    private func subscribeToDidConnect() {
        self.centralManager.didConnectPeripheral
            .sink { peripheral in
                self.didConnect.send(RobotPeripheral(peripheral: peripheral))
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToDidDisconnect() {
        self.centralManager.didDisconnectPeripheral
            .sink { _ in
                self.didDisconnect.send()
            }
            .store(in: &self.cancellables)
    }

    private func subscribeToDidUpdateState() {
        self.centralManager.didUpdateState
            .sink { state in
                self.state.send(state)
                if state == .poweredOn {
                    self.retrieveConnectedRobots()
                }
                if state == .poweredOff {
                    self.disconnect()
                }
            }
            .store(in: &self.cancellables)
    }
}

// MARK: - CBManagerState + CustomStringConvertible

extension CBManagerState: CustomStringConvertible {
    public var description: String {
        switch self {
            case .poweredOn:
                "poweredOn"
            case .poweredOff:
                "poweredOff"
            case .unauthorized:
                "unauthorized"
            case .unknown:
                "unknown"
            case .resetting:
                "resetting"
            case .unsupported:
                "unsupported"
            @unknown default:
                "@unknown default"
        }
    }
}
