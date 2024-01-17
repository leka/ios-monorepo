// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

enum AccountCreationProcess {
    struct NavigationTitle: View {
        var body: some View {
            Text(l10n.AccountCreationProcess.navigationTitle)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.headline)
        }
    }

    struct CarouselView: View {
        var body: some View {
            TabView(selection: self.$selectedTab) {
                Text("First")
                Text("Second")
                Text("Third")
                Text("Fourth")
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}
