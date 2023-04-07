//
//  LKRobotController.swift
//  LekaApp
//
//  Created by Ladislas de Toldi on 23/10/2016.
//  Copyright © 2016 Leka Inc. All rights reserved.
//
import Foundation

//
// MARK: - LKCommand
//
public enum LKCommand {

	// swiftlint:disable colon
	public static let startByte: UInt8 = 0x2A
	public static let startByteLength: UInt8 = 0x04
	public static let ledFull: UInt8 = 0x13
	public static let motor: UInt8 = 0x20
	public static let motivator: UInt8 = 0x50

	//
	// MARK: - LKCommand Led Full
	//
	public enum LedFull {

		public static let command: UInt8 = 0x13
		public static let numberOfValues: UInt8 = 1 + 3 + 1  // EAR/BELT + R, G, B + Checksum
		public static let ears: UInt8 = 0x14
		public static let belt: UInt8 = 0x15

	}

	//
	// MARK: - LKCommand Motors
	//
	public enum Motor {

		public static let command: UInt8 = 0x20
		public static let numberOfValues: UInt8 = 1 + 2 + 1  // Id + Spin, Speed + Checksum
		public static let left: UInt8 = 0x21
		public static let right: UInt8 = 0x22

		public static let forward: UInt8 = 0x01
		public static let backward: UInt8 = 0x00

	}

	//
	// MARK: - LKCommand Motivator
	//
	public enum Motivator {

		public static let command: UInt8 = 0x50
		public static let numberOfValues: UInt8 = 1 + 1  // Motivator + Checksum
		public static let rainbow: UInt8 = 0x51
		public static let fire: UInt8 = 0x52
		public static let sprinkles: UInt8 = 0x53
		public static let spinBlink: UInt8 = 0x54
		public static let blinkGreen: UInt8 = 0x55

	}

	// swiftlint:enable colon
}

func checksum8(_ values: [UInt8]) -> UInt8 {

	var checksum: Int = 0

	for value in values {
		checksum = (Int(value) + checksum) % 256
	}

	return UInt8(checksum)

}

//
// MARK: - CommandKit
//
public class CommandKit {

	//
	// MARK: - Singleton
	//
	static let sharedSingleton = CommandKit()
	public let command = LKCommand.self

	//
	// MARK: - Variables
	//
	var startSequence: [UInt8] = []
	var commandSequence: [UInt8] = []

	var numberOfCommands: Int = 0
	var isEncapsulated: Bool = false

	//
	// MARK: - Initialisation
	//
	public init() {

		for _ in 0...LKCommand.startByteLength - 1 {
			self.startSequence.append(LKCommand.startByte)
		}

	}

	//
	// MARK: - Led Functions
	//
	public func addAllLeds(of earOrBelt: UInt8, rgbColor red: UInt8, _ green: UInt8, _ blue: UInt8) {

		let array = [command.LedFull.command, earOrBelt, red, green, blue, checksum8([earOrBelt, red, green, blue])]

		for element in array {
			commandSequence.append(element)
		}

		numberOfCommands += 1

	}

	//
	// MARK: - Motor Functions
	//
	public func addMotor(on leftOrRight: UInt8, direction: UInt8, speed: UInt8) {

		let array = [command.Motor.command, leftOrRight, direction, speed, checksum8([leftOrRight, direction, speed])]

		for element in array {
			commandSequence.append(element)
		}

		numberOfCommands += 1

	}

	//
	// MARK: - Motivator Functions
	//
	public func addMotivator(_ motivator: UInt8) {

		let array = [command.Motivator.command, motivator, checksum8([motivator])]

		for element in array {
			commandSequence.append(element)
		}

		numberOfCommands += 1

	}

	//
	// MARK: - Command Functions
	//
	func encapsulate() -> [UInt8] {

		var encapsulatedArray: [UInt8] = []

		encapsulatedArray.append(contentsOf: self.startSequence)
		encapsulatedArray.append(UInt8(self.numberOfCommands))
		encapsulatedArray.append(contentsOf: self.commandSequence)

		self.commandSequence = encapsulatedArray
		self.isEncapsulated = true

		return self.commandSequence

	}

	public func getCommands() -> [UInt8] {

		var commands: [UInt8] = []

		if isEncapsulated {
			commands = commandSequence
		} else {
			commands = encapsulate()
		}

		flush()
		return commands

	}

	public func flush() {

		self.commandSequence.removeAll()
		self.numberOfCommands = 0
		self.isEncapsulated = false

	}

}
