// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SVGView
import SwiftUI

struct MemoryChoiceViewImage: View {
    // MARK: Lifecycle

    init(value: String, size: CGFloat, background: Color? = nil) {
        guard let image = Bundle.path(forImage: value) else {
            fatalError("Image \(value) not found")
        }
        self.image = image
        self.size = size
        self.background = background ?? self.choiceBackgroundColor
    }

    // MARK: Internal

    var body: some View {
        if !FileManager.default.fileExists(atPath: self.image) {
            self.imageNotFound()
        }

        if self.image.isRasterImageFile {
            Image(uiImage: UIImage(named: self.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.size, height: self.size)
                .background(self.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
        }

        if self.image.isVectorImageFile {
            SVGView(contentsOf: URL(fileURLWithPath: self.image))
                .frame(width: self.size, height: self.size)
                .background(self.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
        }
    }

    // MARK: Private

    private let background: Color

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private let image: String
    private let size: CGFloat

    private func imageNotFound() -> some View {
        Text("Image not found: \(self.image)")
            .multilineTextAlignment(.center)
            .frame(
                width: self.size,
                height: self.size
            )
            .background(self.background)
            .overlay {
                Circle()
                    .stroke(Color.red, lineWidth: 5)
            }
            .onAppear {
                log.error("Image not found: \(self.image)")
            }
    }
}

#Preview {
    let pngImagePathFromContentKit = "discover_leka"
    let pngImagePath = "image-placeholder-png-boy_sleeping"
    let jpgImagePath = "image-placeholder-jpg-boy_sleeping"
    let svgImagePath = "image-placeholder-svg-boy_sleeping"

    return ScrollView {
        VStack(spacing: 60) {
            HStack(spacing: 70) {
                VStack {
                    Text("PNG")
                        .font(.largeTitle)
                    Text("ContentKit")
                        .font(.caption)
                }
                MemoryChoiceViewImage(value: pngImagePathFromContentKit, size: 200)
            }

            HStack(spacing: 70) {
                Text("PNG")
                    .font(.largeTitle)
                MemoryChoiceViewImage(value: pngImagePath, size: 200)
            }

            HStack(spacing: 70) {
                Text("JPG")
                    .font(.largeTitle)
                MemoryChoiceViewImage(value: jpgImagePath, size: 200)
            }

            HStack(spacing: 70) {
                Text("SVG")
                    .font(.largeTitle)
                MemoryChoiceViewImage(value: svgImagePath, size: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(.lkBackground)
}
