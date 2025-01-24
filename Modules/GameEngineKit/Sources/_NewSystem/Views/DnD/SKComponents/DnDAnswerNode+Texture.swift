// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import RobotKit
import SpriteKit
import SwiftUI

extension DnDAnswerNode {
    static func createImageTexture(value: String, size: CGSize) -> SKTexture {
        guard let path = Bundle.path(forImage: value),
              let image = UIImage(named: path)
        else {
            fatalError("Image not found")
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadiusFactor * size.width)
            path.addClip()
            image.draw(in: rect)
        }

        return SKTexture(image: finalImage)
    }

    static func createSFSymbolTexture(value: String, size _: CGSize) -> SKTexture {
        guard let image = UIImage(systemName: value)
        else {
            fatalError("SFSymbol not found")
        }

        return SKTexture(image: image)
    }

    static func createTextTexture(value: String, size: CGSize) -> SKTexture {
        let rectSize = CGSize(width: size.width, height: size.height)
        let renderer = UIGraphicsImageRenderer(size: rectSize)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: rectSize)

            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadiusFactor * size.width)
            path.addClip()

            UIColor.white.setFill()
            path.fill()

            UIColor.gray.setStroke()
            let strokeWidth: CGFloat = 2
            let borderRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadiusFactor * size.width)
            borderPath.stroke()

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "AvenirNext-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle,
            ]

            let textRect = rect.insetBy(dx: 10, dy: (rect.height - 20) / 2)
            (value as NSString).draw(in: textRect, withAttributes: attributes)
        }

        return SKTexture(image: finalImage)
    }

    static func createEmojiTexture(value: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.height * 0.8),
                .paragraphStyle: paragraphStyle,
            ]

            let emojiRect = rect.offsetBy(dx: 0, dy: (rect.height - size.height) / 2)
            (value as NSString).draw(in: emojiRect, withAttributes: attributes)
        }

        return SKTexture(image: finalImage)
    }

    static func createColorTexture(value: String, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let finalImage = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadiusFactor * size.width)

            let color = Robot.Color(from: value).screen
            UIColor(color).setFill()
            path.fill()

            UIColor.lightGray.setStroke()
            let strokeWidth: CGFloat = 1
            let borderRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: cornerRadiusFactor * size.width)
            borderPath.lineWidth = strokeWidth
            borderPath.stroke()
        }

        return SKTexture(image: finalImage)
    }
}
