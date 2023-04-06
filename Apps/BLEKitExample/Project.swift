//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hugo Pezziardi on 27/03/2023.
//

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(
	name: "BLEKitExample",
	platform: .iOS,
	dependencies: [
		.project(target: "CoreUI", path: Path("../../Modules/CoreUI")),
		.project(target: "BLEKit", path: Path("../../Modules/BLEKit")),
	],
	infoPlist: [
		"NSBluetoothAlwaysUsageDescription":
			"The LekaBLE app needs to use Bluetooth to connect to the Leka robot."
	])
