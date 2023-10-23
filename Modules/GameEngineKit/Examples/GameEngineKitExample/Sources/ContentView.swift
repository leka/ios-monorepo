// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

struct ContentView: View {

    //    let activity = ContentKit.decodeActivity("activity-mixed")
    let activity = ContentKit.decodeActivity("activity-seq1-selection")

    var body: some View {
        VStack {
            ActivityView(viewModel: ActivityViewViewModel(activity: activity))
        }
    }
}
