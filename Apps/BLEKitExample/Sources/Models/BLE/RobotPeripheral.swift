//
//  RobotPeripheral.swift
//  BLEKitExample
//
//  Created by Yann LOCATELLI on 17/02/2023.
//
import CombineCoreBluetooth
import Foundation

class RobotPeripheral: ObservableObject {
	var peripheral: Peripheral

	var notifyingCharacteristics: Set<NotifyingCharacteristic> = []
	var readOnlyCharacteristics: Set<ReadOnlyCharacteristic> = []

	var cancellables: Set<AnyCancellable> = []

	init(peripheral: Peripheral) {
		self.peripheral = peripheral
	}

	func updateData() {
		for characteristic in readOnlyCharacteristics {
			readCharacteristic(on: characteristic)
		}

		discoverAndListenCharacteristics()
	}

	func discoverAndListenCharacteristics() {
		for char in notifyingCharacteristics {

			self.peripheral
				.discoverCharacteristic(
					withUUID: char.characteristicUUID, inServiceWithUUID: char.serviceUUID
				)
				.receive(on: DispatchQueue.main)
				.sink(
					receiveCompletion: { _ in },
					receiveValue: { characteristic in
						print(characteristic)
						self.peripheral.setNotifyValue(true, for: characteristic)
							.assertNoFailure()
							.sink {
								var newChar = char
								newChar.characteristic = characteristic
								self.notifyingCharacteristics.remove(char)
								self.notifyingCharacteristics.insert(newChar)

								self.listenForUpdates(on: newChar)
							}
							.store(in: &self.cancellables)
					}
				)
				.store(in: &cancellables)
		}
	}

	func listenForUpdates(on characteristic: NotifyingCharacteristic) {

		peripheral.listenForUpdates(on: characteristic.characteristic!)
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { _ in
				},
				receiveValue: { data in
					if let data = data {
						characteristic.onNotification?(data)
					}
				}
			)
			.store(in: &cancellables)
	}

	func readCharacteristic(on characteristic: ReadOnlyCharacteristic) {

		peripheral.readValue(
			forCharacteristic: characteristic.characteristicUUID,
			inService: characteristic.serviceUUID
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { data in
				guard let data = data else { return }
				characteristic.onNotification?(data)
			}
		)
		.store(in: &cancellables)
	}

	func writeData(_ data: Data) {

		peripheral.writeValue(
			data,
			writeType: .withoutResponse,
			forCharacteristic: BLESpecs.Commands.Characteristics.tx,
			inService: BLESpecs.Commands.service
		)
		.receive(on: DispatchQueue.main)
		.sink(
			receiveCompletion: { _ in
				// Do nothing
			},
			receiveValue: { _ in
				// Do nothing
			}
		)
		.store(in: &cancellables)
	}
}
