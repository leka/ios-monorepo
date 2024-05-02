// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation
import SVGView
import SwiftUI

public extension StoryView.PageView {
    struct ImageView: View {
        // MARK: Lifecycle

        public init(payload: PagePayloadProtocol) {
            guard let payload = payload as? ImagePayload else {
                fatalError("💥 Story item is not ImagePayload")
            }
            if let path = Bundle.path(forImage: payload.image) {
                log.debug("Image found at path: \(path)")
                self.image = path
            } else {
                log.error("Image not found: \(payload.image)")
                self.image = payload.image
            }
            self.size = CGFloat(payload.size)
            self.text = payload.text
        }

        // MARK: Public

        public var body: some View {
            VStack(spacing: 0) {
                if self.image.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.image)!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: self.size)
                } else if self.image.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.image))
                        .frame(maxWidth: self.size)
                }

                Text(self.text)
                    .font(Font(UIFont(name: "ChalkboardSE-Light", size: CGFloat(26)) ?? .systemFont(ofSize: 26)))
                    .foregroundStyle(.red)
            }
        }

        // MARK: Private

        private let image: String
        private let size: CGFloat
        private let text: String
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView.ImageView(payload: Story.mock.pages[0].items[0].payload)
    }
}
