// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TTSViewAssociateCategories: View {
    var body: some View {
        VStack(spacing: 50) {
            Text("Find the right categories: (1/3), (2/5), (4/6)")
                .font(.title)
            TTSView()
        }
    }
}

#Preview {
    TTSViewAssociateCategories()
}
