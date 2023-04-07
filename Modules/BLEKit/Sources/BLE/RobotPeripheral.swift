//
//  RobotPeripheral.swift
//  BLEKitExample
//
//  Created by Yann LOCATELLI on 17/02/2023.
//
import CombineCoreBluetooth
import Foundation

public class RobotPeripheral: ObservableObject {
	public var peripheral: Peripheral

	public var notifyingCharacteristics: Set<NotifyingCharacteristic> = []
	public var readOnlyCharacteristics: Set<ReadOnlyCharacteristic> = []

	var cancellables: Set<AnyCancellable> = []

	public init(peripheral: Peripheral) {
		self.peripheral = peripheral
	}

	public func updateData() {
		for characteristic in readOnlyCharacteristics {
			readCharacteristic(on: characteristic)
		}

		discoverAndListenCharacteristics()
	}

	public func discoverAndListenCharacteristics() {
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

	public func listenForUpdates(on characteristic: NotifyingCharacteristic) {

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

	public func readCharacteristic(on characteristic: ReadOnlyCharacteristic) {

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

	public func writeData(_ data: Data) {

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
