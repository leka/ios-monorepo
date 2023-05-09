// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class BLEManager {

    // MARK: - @Published variables

    // TODO(@ladislas): review published variables --> are they all needed?
    @Published public var connectedRobotPeripheral: RobotPeripheral?
    public let isScanning = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Private variables

    private var centralManager: CentralManager

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

    // TODO(@ladislas): why use map + return Publisher? why not sink + @Published value?
    public func connect(_ discovery: RobotDiscovery) -> AnyPublisher<RobotPeripheral, Error> {
        return centralManager.connect(discovery.robotPeripheral.peripheral)
            .receive(on: DispatchQueue.main)

            .map { peripheral in
                self.connectedRobotPeripheral = RobotPeripheral(peripheral: peripheral)
                return self.connectedRobotPeripheral!
            }
            .eraseToAnyPublisher()
    }

    public func disconnect() {
        guard let peripheral = connectedRobotPeripheral?.peripheral else { return }

        centralManager.cancelPeripheralConnection(peripheral)

        self.connectedRobotPeripheral = nil
    }

}
