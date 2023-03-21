// Leka - LekaOS
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(
	name: "ColorQuest",
	platform: .iOS,
	dependencies: [
		.project(target: "CoreUI", path: Path("../../Modules/CoreUI")),
		.external(name: "Yams")

	],
	infoPlist: [
		"NSBluetoothAlwaysUsageDescription":
			"The Leka Updater app needs to use Bluetooth to connect to the Leka robot.",
		"UIRequiresFullScreen": "true",
		"UISupportedInterfaceOrientations": ["UIInterfaceOrientationLandscapeLeft"],
		"UISupportedInterfaceOrientations~ipad": [
			"UIInterfaceOrientationLandscapeLeft"
		],
		"LSApplicationCategoryType": "public.app-category.utilities",
	]
)
