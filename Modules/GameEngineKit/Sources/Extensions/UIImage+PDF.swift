// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import UIKit

extension UIImage {
    convenience init?(pdfNamed name: String) {
        guard let image = Self.drawPDFfromFile(named: name) else { return nil }
        self.init(cgImage: image.cgImage!)
    }

    private static func drawPDFfromFile(named fileName: String) -> UIImage? {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "pdf") else { return nil }
        return self.drawPDFfromURL(url: url)
    }

    private static func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { context in
            UIColor.white.set()
            context.fill(pageRect)

            context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)

            context.cgContext.drawPDFPage(page)
        }

        return img
    }
}
