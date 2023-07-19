// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class RobotPeripheral {

    // MARK: - Public variables

    // TODO(@ladislas): should they be published? maybe, need to investigate
    public var peripheral: Peripheral
    public var notifyingCharacteristics: Set<NotifyingCharacteristic> = []
    public var readOnlyCharacteristics: Set<ReadOnlyCharacteristic> = []

    // MARK: - Private variables

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Public functions

    public init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    public func discoverAndListenForUpdates() {
        for char in notifyingCharacteristics {
            self.peripheral
                .discoverCharacteristic(
                    withUUID: char.characteristicUUID, inServiceWithUUID: char.serviceUUID
                )
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { _ in
                        // nothing to do
                    },
                    receiveValue: { characteristic in
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

    public func readReadOnlyCharacteristics() {
        for characteristic in readOnlyCharacteristics {
            peripheral.readValue(
                forCharacteristic: characteristic.characteristicUUID,
                inService: characteristic.serviceUUID
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { data in
                    guard let data = data else { return }
                    characteristic.onRead?(data)
                }
            )
            .store(in: &cancellables)
        }
    }

    public func sendCommand(_ data: Data) {
        peripheral.writeValue(
            data,
            writeType: .withoutResponse,
            forCharacteristic: BLESpecs.Commands.Characteristics.tx,
            inService: BLESpecs.Commands.service
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { _ in
                // nothing to do
            },
            receiveValue: { _ in
                // nothing to do
            }
        )
        .store(in: &cancellables)
    }

    public func send(_ data: Data, forCharacteristic characteristic: WriteOnlyCharacteristic) {
        peripheral.writeValue(
            data,
            writeType: .withoutResponse,
            forCharacteristic: characteristic.characteristicUUID,
            inService: characteristic.serviceUUID
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { _ in
                characteristic.onWrite?()
            },
            receiveValue: { _ in
                // nothing to do
            }
        )
        .store(in: &cancellables)
    }

    // MARK: - Private functions

    private func listenForUpdates(on characteristic: NotifyingCharacteristic) {
        peripheral.listenForUpdates(on: characteristic.characteristic!)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { data in
                    if let data = data {
                        characteristic.onNotification?(data)
                    }
                }
            )
            .store(in: &cancellables)
    }

}
