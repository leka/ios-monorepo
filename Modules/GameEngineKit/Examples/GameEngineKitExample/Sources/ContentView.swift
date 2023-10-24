// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

struct ContentView: View {

    let activity = ContentKit.ActivityList.seq1Selection

    var body: some View {
        VStack {
            ActivityView(viewModel: ActivityViewViewModel(activity: activity))
        }
    }

}
