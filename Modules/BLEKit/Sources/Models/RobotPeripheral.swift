// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import CombineCoreBluetooth

public class RobotPeripheral: Equatable {
    // MARK: Lifecycle

    // MARK: - Public functions

    public init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    // MARK: Public

    // MARK: - Public variables

    // TODO(@ladislas): should they be published? maybe, need to investigate
    public var peripheral: Peripheral
    public var notifyingCharacteristics: Set<CharacteristicModelNotifying> = []
    public var readOnlyCharacteristics: Set<CharacteristicModelReadOnly> = []

    public static func == (lhs: RobotPeripheral, rhs: RobotPeripheral) -> Bool {
        lhs.peripheral.id == rhs.peripheral.id
    }

    public func discoverAndListenForUpdates() {
        for char in self.notifyingCharacteristics {
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
                                let newCharacteristic = CharacteristicModelNotifying(
                                    characteristicUUID: char.characteristicUUID,
                                    serviceUUID: char.serviceUUID,
                                    cbCharacteristic: characteristic,
                                    onNotification: char.onNotification
                                )

                                self.notifyingCharacteristics.remove(char)
                                self.notifyingCharacteristics.insert(newCharacteristic)

                                self.listenForUpdates(on: newCharacteristic)
                            }
                            .store(in: &self.cancellables)
                    }
                )
                .store(in: &self.cancellables)
        }
    }

    public func readReadOnlyCharacteristics() {
        for characteristic in self.readOnlyCharacteristics {
            self.peripheral.readValue(
                forCharacteristic: characteristic.characteristicUUID,
                inService: characteristic.serviceUUID
            )
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { data in
                    guard let data else { return }
                    characteristic.onRead?(data)
                }
            )
            .store(in: &self.cancellables)
        }
    }

    public func sendCommand(_ data: Data) {
        self.peripheral.writeValue(
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
        .store(in: &self.cancellables)
    }

    public func send(_ data: Data, forCharacteristic characteristic: CharacteristicModelWriteOnly) {
        self.peripheral.writeValue(
            data,
            writeType: .withResponse,
            forCharacteristic: characteristic.characteristicUUID,
            inService: characteristic.serviceUUID
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        characteristic.onWrite?()
                    case let .failure(error):
                        print("💥 ERROR: \(error)")
                }
            },
            receiveValue: { _ in
                // nothing to do
            }
        )
        .store(in: &self.cancellables)
    }

    // MARK: Private

    // MARK: - Private variables

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Private functions

    private func listenForUpdates(on characteristic: CharacteristicModelNotifying) {
        self.peripheral.listenForUpdates(on: characteristic.cbCharacteristic!)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in
                    // nothing to do
                },
                receiveValue: { data in
                    if let data {
                        characteristic.onNotification?(data)
                    }
                }
            )
            .store(in: &self.cancellables)
    }
}
