// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RemoteNavigationGroup: View {

    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(RemotePreviews.allCases, id: \.rawValue) { item in
                PreviewButton(item: .constant(item))
            }
        }
        .padding(20)
    }
}
