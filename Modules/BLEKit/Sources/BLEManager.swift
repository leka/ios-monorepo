// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class BLEManager {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(centralManager: CentralManager) {
        self.centralManager = centralManager

        self.subscribeToDidDisconnect()
        self.subscribeToDidConnect()
    }

    // MARK: Public

    #if targetEnvironment(simulator)
        public static var shared: BLEManager = .init(centralManager: .live())
    #else
        public static var shared: BLEManager = .init(
            centralManager: .live(
                ManagerCreationOptions(showPowerAlert: true, restoreIdentifier: "io.leka.module.BLEKit.Manager.live"))
        )
    #endif

    // MARK: - @Published variables

    public let isScanning = CurrentValueSubject<Bool, Never>(false)
    public let didConnect = PassthroughSubject<RobotPeripheral, Never>()
    public let didDisconnect = PassthroughSubject<Void, Never>()

    public var isConnected: Bool {
        self.connectedRobotPeripheral != nil ? true : false
    }

    public static func live() -> BLEManager {
        BLEManager(centralManager: CentralManager.live())
    }

    public func scanForRobots() -> AnyPublisher<[RobotDiscoveryModel], Error> {
        self.centralManager.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])
            .handleEvents(
                receiveSubscription: { _ in
                    if self.centralManager.state == .poweredOn {
                        self.isScanning.send(true)
                    } else {
                        self.isScanning.send(false)
                    }
                },
                receiveCancel: {
                    self.isScanning.send(false)
                }
            )
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
                peripheralDiscoveries.compactMap { peripheralDiscovery in
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
        self.centralManager.connect(discovery.robotPeripheral.peripheral)
            .compactMap { peripheral in
                self.connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
                return self.connectedRobotPeripheral
            }
            .eraseToAnyPublisher()
    }

    public func disconnect() {
        guard let connectedPeripheral = connectedRobotPeripheral?.peripheral else { return }
        self.centralManager.cancelPeripheralConnection(connectedPeripheral)
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
}
