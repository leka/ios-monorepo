// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class BLEManager {

    // MARK: - @Published variables

    public let isScanning = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Private variables

    private var centralManager: CentralManager
    private var connectedRobotPeripheral: RobotPeripheral?

    // MARK: - Public functions

    public init(centralManager: CentralManager) {
        self.centralManager = centralManager
    }

    public static func live() -> BLEManager {
        return BLEManager(centralManager: CentralManager.live())
    }

    public func scanForRobots() -> AnyPublisher<[RobotDiscovery], Error> {
        return centralManager.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])
            .handleEvents(
                receiveSubscription: { _ in
                    self.isScanning.send(true)
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
                            return $0.id == discovery.id
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

                    return RobotDiscovery(
                        robotPeripheral: robotPeripheral, advertisingData: robotAdvertisingData, rssi: rssi)
                }

            }
            .eraseToAnyPublisher()
    }

    public func connect(_ discovery: RobotDiscovery) -> AnyPublisher<RobotPeripheral, Error> {
        return centralManager.connect(discovery.robotPeripheral.peripheral)
            // TODO(@ladislas): check if receive is needed here
            .receive(on: DispatchQueue.main)
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

}
