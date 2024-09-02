// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct TTSViewFindTheRightOrder: View {
    var body: some View {
        VStack(spacing: 50) {
            Text("Find the right order: 1, 2, 3, 4, 5, 6")
                .font(.title)
            TTSView()
        }
    }
}

#Preview {
    TTSViewFindTheRightOrder()
}
