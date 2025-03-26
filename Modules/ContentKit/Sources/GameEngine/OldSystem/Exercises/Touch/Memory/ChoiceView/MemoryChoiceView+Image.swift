// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SVGView
import SwiftUI

extension MemoryChoiceView {
    struct ImageView: View {
        // MARK: Lifecycle

        init(image: String, size: CGFloat, background: Color? = nil, state: GameplayChoiceState = .idle) {
            guard let image = Bundle.path(forImage: image) else {
                fatalError("Image \(image) not found")
            }
            self.image = image
            self.size = size
            self.state = state
            self.background = background ?? self.choiceBackgroundColor
        }

        // MARK: Internal

        @State var degree: Double = 90.0

        @ViewBuilder
        var choice: some View {
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
                    .rotation3DEffect(Angle(degrees: self.degree), axis: (x: self.nearZeroFloat, y: 1, z: self.nearZeroFloat))
            }

            if self.image.isVectorImageFile {
                SVGView(contentsOf: URL(fileURLWithPath: self.image))
                    .frame(width: self.size, height: self.size)
                    .background(self.background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 4)
                    .rotation3DEffect(Angle(degrees: self.degree), axis: (x: 0, y: 1, z: 0))
            }
        }

        var body: some View {
            switch self.state {
                case .idle:
                    self.choice
                        .onAppear {
                            withAnimation(.linear(duration: self.kDurationAndDelay)) {
                                self.degree = 90.0
                            }
                        }

                case .selected,
                     .rightAnswer:
                    self.choice
                        .onAppear {
                            withAnimation(.linear(duration: self.kDurationAndDelay).delay(self.kDurationAndDelay)) {
                                self.degree = 0.0
                            }
                        }

                default:
                    EmptyView()
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
        private let state: GameplayChoiceState
        private let kDurationAndDelay: Double = 0.2
        private let nearZeroFloat: CGFloat = 0.0001

        private func imageNotFound() -> some View {
            Text(l10n.ChoiceImageView.imageUnknownError(self.image))
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
                    logGEK.error("Image not found: \(self.image)")
                }
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
                MemoryChoiceView.ImageView(image: pngImagePathFromContentKit, size: 200, state: .idle)
                MemoryChoiceView.ImageView(image: pngImagePathFromContentKit, size: 200, state: .selected)
                MemoryChoiceView.ImageView(image: pngImagePathFromContentKit, size: 200, state: .rightAnswer)
                MemoryChoiceView.ImageView(image: pngImagePathFromContentKit, size: 200, state: .wrongAnswer)
            }

            HStack(spacing: 70) {
                Text("PNG")
                    .font(.largeTitle)
                MemoryChoiceView.ImageView(image: pngImagePath, size: 200, state: .idle)
                MemoryChoiceView.ImageView(image: pngImagePath, size: 200, state: .selected)
                MemoryChoiceView.ImageView(image: pngImagePath, size: 200, state: .rightAnswer)
                MemoryChoiceView.ImageView(image: pngImagePath, size: 200, state: .wrongAnswer)
            }

            HStack(spacing: 70) {
                Text("JPG")
                    .font(.largeTitle)
                MemoryChoiceView.ImageView(image: jpgImagePath, size: 200, state: .idle)
                MemoryChoiceView.ImageView(image: jpgImagePath, size: 200, state: .selected)
                MemoryChoiceView.ImageView(image: jpgImagePath, size: 200, state: .rightAnswer)
                MemoryChoiceView.ImageView(image: jpgImagePath, size: 200, state: .wrongAnswer)
            }

            HStack(spacing: 70) {
                Text("SVG")
                    .font(.largeTitle)
                MemoryChoiceView.ImageView(image: svgImagePath, size: 200, state: .idle)
                MemoryChoiceView.ImageView(image: svgImagePath, size: 200, state: .selected)
                MemoryChoiceView.ImageView(image: svgImagePath, size: 200, state: .rightAnswer)
                MemoryChoiceView.ImageView(image: svgImagePath, size: 200, state: .wrongAnswer)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    .background(.lkBackground)
}
