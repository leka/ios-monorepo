//
//  BLEManager.swift
//  LekaBLE
//
//  Created by Yann LOCATELLI on 17/02/2023.
//
import CoreBluetooth
import Foundation

class BLEManager: NSObject, CBCentralManagerDelegate, ObservableObject {
	private var central: CBCentralManager?
	var peripherals: [CBPeripheral: BLEPeripheral] = [:]

	private var advertisingServicesFilter: [CBUUID]

	var onPeripheralDetected: ((BLEPeripheral) -> Void)?

	init(advertisingServicesFilter: [CBUUID] = []) {
		self.advertisingServicesFilter = advertisingServicesFilter

		super.init()

		self.central = CBCentralManager(delegate: self, queue: nil)
	}

	func connect(to blePeripheral: BLEPeripheral) {
		guard let central = self.central else { return }
		guard let peripheral = blePeripheral.peripheral else { return }

		central.stopScan()
		central.connect(peripheral)
	}

	func disconnect(from blePeripheral: BLEPeripheral) {
		guard let central = self.central else { return }
		guard let peripheral = blePeripheral.peripheral else { return }

		central.cancelPeripheralConnection(peripheral)
	}

	internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
			case .unknown:
				print("central.state is .unknown")
			case .resetting:
				print("central.state is .resetting")
			case .unsupported:
				print("central.state is .unsupported")
			case .unauthorized:
				print("central.state is .unauthorized")
			case .poweredOff:
				print("central.state is .poweredOff")
			case .poweredOn:
				print("central.state is .poweredOn")
				central.scanForPeripherals(withServices: advertisingServicesFilter)
			default:
				print("Unknown issue")
		}
	}

	internal func centralManager(
		_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any],
		rssi RSSI: NSNumber
	) {
		if peripherals[peripheral] == nil {
			peripherals[peripheral] = BLEPeripheral(peripheral: peripheral)
		}
		print("Discover new peripheral")
		peripherals[peripheral]!.advertisingDataUpdate(advertisementData)

		if let callback = onPeripheralDetected {
			callback(peripherals[peripheral]!)
		}
	}

	internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
		peripheral.delegate = peripherals[peripheral]
		peripheral.discoverServices(nil)
	}

	internal func centralManager(
		_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?
	) {
		central.scanForPeripherals(withServices: advertisingServicesFilter)
	}
}
