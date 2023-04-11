//
//  BLEManager.swift
//  BLEKitExample
//
//  Created by Hugo Pezziardi on 29/03/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import CombineCoreBluetooth

public class BLEManager: ObservableObject {
	var centralManager: CentralManager

	public init(centralManager: CentralManager) {
		self.centralManager = centralManager
	}

	public static func live() -> BLEManager {
		return BLEManager(centralManager: CentralManager.live())
	}

	@Published public var peripherals: [PeripheralDiscovery] = []
	@Published var connectedPeripheralResult: Result<Peripheral, Error>?
	@Published public var isScanning: Bool = false

	public var scanTask: AnyCancellable?
	public var cancellables: Set<AnyCancellable> = []

	public var connectedPeripheral: Peripheral?

	public func searchForPeripherals() {
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
				self?.peripherals = $0
			})

		self.isScanning = centralManager.isScanning
	}

	public func stopSearching() {
		scanTask?.cancel()
		peripherals = []
		self.isScanning = centralManager.isScanning
	}

	public func connect(_ discovery: PeripheralDiscovery) -> AnyPublisher<Peripheral, Error> {
		return centralManager.connect(discovery.peripheral)
			.map {
				self.connectedPeripheral = $0
				return self.connectedPeripheral!
			}
			.eraseToAnyPublisher()
	}

	public func disconnect() {
		guard let connectedPeripheral = connectedPeripheral else { return }

		centralManager.cancelPeripheralConnection(connectedPeripheral)

		self.connectedPeripheral = nil
	}

}
