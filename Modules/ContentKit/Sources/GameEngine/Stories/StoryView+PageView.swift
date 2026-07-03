// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SVGView
import SwiftUI

public extension StoryView {
    struct PageView: View {
        // MARK: Lifecycle

        public init(page: Page) {
            guard let image = Bundle.path(forImage: page.background) else {
                fatalError("Image not found")
            }
            self.background = image
            self.items = page.items
        }

        // MARK: Public

        public var body: some View {
            ZStack {
                if self.background.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.background)!)
                        .resizable()
                        .scaledToFill()
                } else if self.background.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.background))
                        .scaledToFill()
                } else {
                    Color.lkBackground
                }

                HStack(alignment: .firstTextBaseline) {
                    ForEach(self.items) { item in
                        switch item.type {
                            case .image:
                                ImageView(payload: item.payload)
                            case .text:
                                TextView(payload: item.payload)
                            case .buttonImage:
                                ButtonImageView(payload: item.payload)
                        }
                    }
                }
            }
            .ignoresSafeArea(.all)
        }

        // MARK: Private

        private let background: String
        private let items: [Page.Item]
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView(page: Story.mock.pages[2])
    }
}
