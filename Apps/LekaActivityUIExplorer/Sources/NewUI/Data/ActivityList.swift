// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

let kListOfAvailablesActivities: [ActivityModel] = [
    ActivityModel(
        title: "Text Activity #1",
        instructions: "This is just another test",
        view: AnyView(TestActivity())
    ),
    ActivityModel(
        title: "Text Activity #2",
        instructions: "This is just another test",
        view: AnyView(TestActivity())
    ),
    ActivityModel(
        title: "Melody",
        instructions: "Play the song with Leka",
        view: AnyView(MelodyActivity())
    ),
]
