// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

// MARK: - NewsView

struct NewsView: View {
    @ObservedObject var rootOwnerViewModel: RootOwnerViewModel = .shared

    var body: some View {
        VStack {
            Text("Hello, What's new!")
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    NewsView()
}
