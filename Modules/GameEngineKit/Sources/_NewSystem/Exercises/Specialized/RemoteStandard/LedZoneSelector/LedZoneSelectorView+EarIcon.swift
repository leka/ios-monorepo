// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension LedZoneSelectorView {
    struct EarIcon: View {
        var body: some View {
            Circle()
                .foregroundColor(.black)
                .frame(width: 10, height: 10)
        }
    }
}

#Preview {
    LedZoneSelectorView.EarIcon()
}
