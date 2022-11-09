// Leka - LekaOS
// Copyright 2022 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription
import ProjectDescriptionHelpers

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.module(name: "CoreUI",
							 platform: .iOS,
							 dependencies: [.project(target: "CoreLogger", path: "../CoreLogger")])
