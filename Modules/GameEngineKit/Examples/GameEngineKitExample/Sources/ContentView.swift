// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct ContentView: View {

    var body: some View {
        //        ThreeChoicesInlineView(viewModel: oneAnswerThreeInlineVM)

        SixChoicesGridView(viewModel: oneAnswerSixGridVM)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
