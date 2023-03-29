// Leka - LekaOS
// Copyright 2022 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(
	name: "LekaApp",
	platform: .iOS,
	dependencies: [
		.project(target: "CoreUI", path: Path("../../Modules/CoreUI")),
		.external(name: "Yams"),
		.external(name: "Lottie"),
	],
	infoPlist: [
		"NSAccentColorName": "AccentColor"
	])
