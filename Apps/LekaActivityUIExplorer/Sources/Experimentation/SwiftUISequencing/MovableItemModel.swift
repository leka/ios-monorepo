// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - MovableItemData

struct MovableItemData: Identifiable, Equatable {
    let id = UUID()
    var color: Color
    var image: Image?
    var size = CGSize(width: 110, height: 110)
}

// MARK: - MovableItem

struct MovableItem: View {
    let data: MovableItemData

    var body: some View {
        Group {
            if let image = data.image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(self.data.color.gradient)
            }
        }
        .frame(width: self.data.size.width, height: self.data.size.height)
    }
}
