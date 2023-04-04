//
//  Central.swift
//  LekaCombineCB
//
//  Created by Hugo Pezziardi on 29/03/2023.
//  Copyright © 2023 leka.io. All rights reserved.
//

import CombineCoreBluetooth

class Central: ObservableObject {
	let centralManager: CentralManager = .live()

	@Published var peripherals: [PeripheralDiscovery] = []
	@Published var peripheralConnectResult: Result<Peripheral, Error>?
	@Published var scanning: Bool = false

	var scanTask: AnyCancellable?
	var cancellables: Set<AnyCancellable> = []

	var connectedPeripheral: Peripheral? {
		guard case let .success(value) = peripheralConnectResult else { return nil }
		return value
	}

	var connectError: Error? {
		guard case let .failure(value) = peripheralConnectResult else { return nil }
		return value
	}

	func searchForPeripherals() {
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

		self.scanning = centralManager.isScanning
	}

	func stopSearching() {
		scanTask = nil
		peripherals = []
		self.scanning = centralManager.isScanning
	}

	func connect(_ discovery: PeripheralDiscovery) {
		centralManager.connect(discovery.peripheral)
			.map(Result.success)
			.catch({ Just(Result.failure($0)) })
			.receive(on: DispatchQueue.main)
			.assign(to: &$peripheralConnectResult)
	}

	func disconnect(_ peripheral: Peripheral) {
		centralManager.cancelPeripheralConnection(peripheral)
	}

}
