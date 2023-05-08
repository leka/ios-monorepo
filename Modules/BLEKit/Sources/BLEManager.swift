// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class BLEManager: ObservableObject {

    // MARK: - @Published variables

    // TODO(@ladislas): review published variables --> are they all needed?
    @Published public var robotDiscoveries: [PeripheralDiscovery] = []
    @Published public var connectedRobotPeripheral: Peripheral?
    @Published public var isScanning: Bool = false

    // MARK: - Public variables

    // TODO(@ladislas): review its use --> create bags in clases where it's used instead of using this one.
    public var cancellables: Set<AnyCancellable> = []

    // MARK: - Private variables

    private var scanTask: AnyCancellable?
    private var centralManager: CentralManager

    // MARK: - Public functions

    public init(centralManager: CentralManager) {
        self.centralManager = centralManager
    }

    public static func live() -> BLEManager {
        return BLEManager(centralManager: CentralManager.live())
    }

    public func scanForRobots() {
        scanTask = centralManager.scanForPeripherals(withServices: [BLESpecs.AdvertisingData.service])
            .scan(
                [],
                { list, discovery -> [PeripheralDiscovery] in
                    guard let index = list.firstIndex(where: { $0.id == discovery.id }) else {
                        return list + [discovery]
                    }
                    var newList = list
                    newList[index] = discovery
                    return newList
                }
            )
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else {
                    return
                }
                self.robotDiscoveries = $0
            })

        self.isScanning = centralManager.isScanning
    }

    public func stopScanning() {
        scanTask?.cancel()
        robotDiscoveries = []
        self.isScanning = centralManager.isScanning
    }

    public func connect(_ discovery: PeripheralDiscovery) -> AnyPublisher<Peripheral, Error> {
        return centralManager.connect(discovery.peripheral)
            .receive(on: DispatchQueue.main)
            .map {
                self.connectedRobotPeripheral = $0
                // TODO(@ladislas): should we really return? why not just use the Published property to get the update?
                return self.connectedRobotPeripheral!
            }
            .eraseToAnyPublisher()
    }

    public func disconnect() {
        guard let connectedPeripheral = connectedRobotPeripheral else { return }

        centralManager.cancelPeripheralConnection(connectedPeripheral)

        self.connectedRobotPeripheral = nil
    }

}
