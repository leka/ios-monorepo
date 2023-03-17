// Leka - LekaOS
// Copyright 2022 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "LekaUpdater",
						  platform: .iOS,
						  dependencies: [
							.project(target: "CoreUI", path: Path("../../Modules/CoreUI"))
						  ],
						  infoPlist: [
							"os_version": "1.4.0",
							"NSBluetoothAlwaysUsageDescription": "The Leka Updater app needs to use Bluetooth to connect to the Leka robot.",
							"UIRequiresFullScreen": "true",
							"UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
							"UISupportedInterfaceOrientations~ipad": [
								"UIInterfaceOrientationPortrait",
								"UIInterfaceOrientationPortraitUpsideDown"
							],
							"LSApplicationCategoryType": "public.app-category.utilities"
						  ]
)
