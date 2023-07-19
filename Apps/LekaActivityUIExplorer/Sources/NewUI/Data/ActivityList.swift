// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

let kListOfAvailablesActivities: [ActivityModel] = [
    ActivityModel(
        title: "Melody",
        instructions: "Play the right melody",
        view: AnyView(MelodyActivity())
    ),
    ActivityModel(
        title: "Text Activity #2",
        instructions: "This is just another test",
        view: AnyView(TestActivity())
    ),
]
