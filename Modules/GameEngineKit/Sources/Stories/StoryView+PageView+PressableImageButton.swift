// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import Foundation
import SVGView
import SwiftUI

public extension StoryView.PageView {
    struct PressableImageButton: View {
        // MARK: Lifecycle

        public init(idleImage: String, pressedImage: String, action: (() -> Void)? = nil) {
            self.idleImage = idleImage
            self.pressedImage = pressedImage
            self.action = action
        }

        // MARK: Public

        public var body: some View {
            VStack {
                if self.isPressed {
                    if self.pressedImage.isRasterImageFile {
                        Image(uiImage: UIImage(named: self.pressedImage)!)
                            .resizable()
                            .scaledToFit()
                    } else if self.pressedImage.isVectorImageFile {
                        SVGView(contentsOf: URL(fileURLWithPath: self.pressedImage))
                    }
                } else {
                    if self.idleImage.isRasterImageFile {
                        Image(uiImage: UIImage(named: self.idleImage)!)
                            .resizable()
                            .scaledToFit()
                    } else if self.idleImage.isVectorImageFile {
                        SVGView(contentsOf: URL(fileURLWithPath: self.idleImage))
                    }
                }
            }
            .frame(maxWidth: 180)
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

        private let idleImage: String
        private let pressedImage: String
        private let action: (() -> Void)?
    }
}
