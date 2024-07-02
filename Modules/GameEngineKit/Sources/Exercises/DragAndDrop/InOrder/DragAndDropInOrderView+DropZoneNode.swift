// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SpriteKit
import SwiftUI

extension DragAndDropInOrderView {
    class DropZoneNode: SKSpriteNode {
        // MARK: Lifecycle

        init(size: CGSize, position: CGPoint) {
            let image = DropZoneNode.createRoundedRectImage(size: size)
            let texture = SKTexture(image: image)

            super.init(texture: texture, color: .clear, size: size)
            self.position = position
            self.defaultPosition = position
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Internal

        var defaultPosition: CGPoint?

        // MARK: Private

        private static func createRoundedRectImage(size: CGSize) -> UIImage {
            let rect = CGRect(origin: .zero, size: size)

            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            let context = UIGraphicsGetCurrentContext()!

            context.setFillColor(UIColor.gray.cgColor)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
            path.fill()

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image!
        }
    }
}
