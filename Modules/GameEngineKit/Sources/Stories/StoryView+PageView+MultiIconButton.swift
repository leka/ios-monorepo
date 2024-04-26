// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation
import SVGView
import SwiftUI

public extension StoryView.PageView {
    struct MultiIconButton: View {
        // MARK: Lifecycle

        public init(image: String, pressed: String, action: (() -> Void)? = nil) {
            self.image = image
            self.pressed = pressed
            self.action = action
        }

        // MARK: Public

        public var body: some View {
            VStack {
                if self.isPressed {
                    if self.pressed.isRasterImageFile {
                        Image(uiImage: UIImage(named: self.pressed)!)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                    } else if self.pressed.isVectorImageFile {
                        SVGView(contentsOf: URL(fileURLWithPath: self.pressed))
                            .frame(maxWidth: 200)
                    }
                } else {
                    if self.image.isRasterImageFile {
                        Image(uiImage: UIImage(named: self.image)!)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                    } else if self.image.isVectorImageFile {
                        SVGView(contentsOf: URL(fileURLWithPath: self.image))
                            .frame(maxWidth: 200)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        self.isPressed = true
                        if let action = self.action {
                            action()
                        }
                    }
                    .onEnded { _ in
                        self.isPressed = false
                    }
            )
        }

        // MARK: Private

        @State private var isPressed = false

        private let image: String
        private let pressed: String
        private let action: (() -> Void)?
    }
}
