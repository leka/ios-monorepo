// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct GameBackgroundView: View {

    @ObservedObject var defaults: DefaultsTemplate

    var body: some View {
        defaults.activitiesBackgroundColor.edgesIgnoringSafeArea(.all)
    }
}
