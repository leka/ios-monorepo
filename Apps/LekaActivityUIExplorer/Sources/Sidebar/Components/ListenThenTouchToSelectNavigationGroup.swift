// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ListenThenTouchToSelectNavigationGroup: View {

    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(ListenThenTouchToSelectPreviews.allCases, id: \.rawValue) { item in
                PreviewButton(item: .constant(item), accessory: "speaker.wave.2.circle")
            }
        }
        .padding(20)
    }
}
