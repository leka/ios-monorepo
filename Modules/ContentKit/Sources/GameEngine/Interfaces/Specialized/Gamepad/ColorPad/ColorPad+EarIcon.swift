// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

extension ColorPad {
    struct EarIcon: View {
        var body: some View {
            Circle()
                .foregroundColor(.black)
                .frame(width: 10, height: 10)
        }
    }
}

#Preview {
    ColorPad.EarIcon()
}
