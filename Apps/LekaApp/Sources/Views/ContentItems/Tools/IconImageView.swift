// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - IconImageView

struct IconImageView: View {
    let image: UIImage?

    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.secondary)
                .scaledToFit()
                .frame(width: 40)
                .padding(.horizontal, 5)
        } else {
            Color.clear
                .frame(width: 40, height: 40)
        }
    }
}
