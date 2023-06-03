// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DragAndDropNavigationGroup: View {

    let action: () -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(DragAndDropPreviews.allCases, id: \.rawValue) { item in
                PreviewButton(item: .constant(item), action: { action() })
            }
        }
        .padding(20)
    }
}
