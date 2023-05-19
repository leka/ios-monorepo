// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TouchToSelectNavigationGroup: View {

    @EnvironmentObject var navigator: NavigationManager
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @EnvironmentObject var configuration: GameLayoutTemplatesConfigurations

    let action: () -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem()]) {
            ForEach(TouchToSelectPreviews.allCases, id: \.rawValue) { item in
                PreviewButton(item: .constant(item), action: { action() })
            }
        }
        .padding(20)
    }
}
