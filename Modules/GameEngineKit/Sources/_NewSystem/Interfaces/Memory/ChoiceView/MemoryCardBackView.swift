// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MemoryCardBackView: View {
    // MARK: Lifecycle

    init(size: CGFloat) {
        self.size = size
    }

    // MARK: Internal

    var body: some View {
        Image(uiImage: UIImage(named: Bundle.path(forImage: "memory_back_of_cards")!)!)
            .resizable()
            .frame(
                width: self.size,
                height: self.size
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
    }

    // MARK: Private

    private let size: CGFloat
}

#Preview {
    MemoryCardBackView(size: 200)
}
