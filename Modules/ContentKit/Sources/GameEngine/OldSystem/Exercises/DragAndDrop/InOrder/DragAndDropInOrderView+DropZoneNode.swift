// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
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

        private static let dropzoneBackgroundColor: UIColor = .init(
            light: UIColor.white,
            dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
        )

        private static func createRoundedRectImage(size: CGSize) -> UIImage {
            let rect = CGRect(origin: .zero, size: size)
            let cornerRadius: CGFloat = 10 / 57 * size.width
            let strokeWidth: CGFloat = 2.0

            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { context in
                let context = context.cgContext

                // ? Fill the background
                context.setFillColor(self.dropzoneBackgroundColor.cgColor)
                let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
                path.fill()

                // ? Draw the border to be homogenous around the shape
                context.setStrokeColor(UIColor.gray.cgColor)
                context.setLineWidth(strokeWidth)
                let borderRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
                let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadius - strokeWidth / 2)
                borderPath.stroke()
            }

            return image
        }
    }
}
