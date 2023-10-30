// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class BLEManager {

    public static var shared: BLEManager = BLEManager(
        centralManager: .live(
            ManagerCreationOptions(showPowerAlert: true, restoreIdentifier: "io.leka.module.BLEKit.Manager.live")))

    // MARK: - @Published variables

    public let isScanning = CurrentValueSubject<Bool, Never>(false)
    public let didConnect = PassthroughSubject<RobotPeripheral, Never>()
    public let didDisconnect = PassthroughSubject<Void, Never>()

    public var isConnected: Bool {
        connectedRobotPeripheral != nil ? true : false
    }

    // MARK: - Private variables

    private var centralManager: CentralManager
    private var connectedRobotPeripheral: RobotPeripheral?

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public functions

    public init(centralManager: CentralManager) {
        self.centralManager = centralManager

        self.subscribeToDidDisconnect()
        self.subscribeToDidConnect()
    }

    public static func live() -> BLEManager {
        BLEManager(centralManager: CentralManager.live())
    }

    public func scanForRobots() -> AnyPublisher<[RobotDiscoveryModel], Error> {
        centralManager.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])
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
                    guard
                        let index = list.firstIndex(where: {
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
                    guard
                        let robotAdvertisingData = RobotAdvertisingData(
                            advertisementData: peripheralDiscovery.advertisementData),
                        let rssi = peripheralDiscovery.rssi
                    else {
                        return nil
                    }

                    let robotPeripheral = RobotPeripheral(peripheral: peripheralDiscovery.peripheral)

                    return RobotDiscoveryModel(
                        robotPeripheral: robotPeripheral, advertisingData: robotAdvertisingData, rssi: rssi)
                }

            }
            .eraseToAnyPublisher()
    }

    public func connect(_ discovery: RobotDiscoveryModel) -> AnyPublisher<RobotPeripheral, Error> {
        centralManager.connect(discovery.robotPeripheral.peripheral)
            .compactMap { peripheral in
                self.connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
                return self.connectedRobotPeripheral
            }
            .eraseToAnyPublisher()
    }

    public func disconnect() {
        guard let connectedPeripheral = self.connectedRobotPeripheral?.peripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral)
    }

    // MARK: - Private functions

    private func subscribeToDidConnect() {
        self.centralManager.didConnectPeripheral
            .sink { peripheral in
                self.didConnect.send(RobotPeripheral(peripheral: peripheral))
            }
            .store(in: &cancellables)
    }

    private func subscribeToDidDisconnect() {
        self.centralManager.didDisconnectPeripheral
            .sink { _ in
                self.didDisconnect.send()
            }
            .store(in: &cancellables)
    }
}
