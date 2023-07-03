// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DanceFreezeNavigationGroup: View {
    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(DanceFreezePreviews.allCases, id: \.rawValue) { item in
                PreviewButton(item: .constant(item))
            }
        }
        .padding(20)
    }
}
