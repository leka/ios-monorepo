// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import RobotKit
import SVGView
import SwiftUI

// MARK: - ChoiceImageView

public struct ChoiceImageView: View {
    // MARK: Lifecycle

    public init(image: String, size: CGFloat, background: Color? = nil, state: GameplayChoiceState = .idle) {
        self.image = image
        self.size = size
        self.state = state
        self.background = background ?? self.choiceBackgroundColor
    }

    // MARK: Public

    public var body: some View {
        switch self.state {
            case .idle:
                self.circle
                    .onAppear {
                        withAnimation {
                            self.animationPercent = 0.0
                            self.overlayOpacity = 0.0
                        }
                    }

            case .rightAnswer:
                self.circle
                    .overlay {
                        RightAnswerFeedback(animationPercent: self.animationPercent)
                            .frame(
                                width: self.size * self.kOverLayScaleFactor,
                                height: self.size * self.kOverLayScaleFactor
                            )
                    }
                    .onAppear {
                        withAnimation {
                            self.animationPercent = 1.0
                        }
                    }

            case .wrongAnswer:
                self.circle
                    .overlay {
                        WrongAnswerFeedback(overlayOpacity: self.overlayOpacity)
                            .frame(
                                width: self.size * self.kOverLayScaleFactor,
                                height: self.size * self.kOverLayScaleFactor
                            )
                    }
                    .onAppear {
                        withAnimation {
                            self.overlayOpacity = 0.8
                        }
                    }
        }
    }

    // MARK: Internal

    @ViewBuilder
    var circle: some View {
        if !FileManager.default.fileExists(atPath: self.image) {
            self.imageNotFound()
        }

        if self.image.isRasterImageFile {
            Image(uiImage: UIImage(named: self.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.size, height: self.size)
                .background(self.background)
                .clipShape(Circle())
        }

        if self.image.isVectorImageFile {
            SVGView(contentsOf: URL(fileURLWithPath: self.image))
                .frame(width: self.size, height: self.size)
                .background(self.background)
                .clipShape(Circle())
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
    private let kOverLayScaleFactor: CGFloat = 1.08

    @State private var animationPercent: CGFloat = .zero
    @State private var overlayOpacity: CGFloat = .zero

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
                log.error("Image not found: \(self.image)")
            }
    }
}

// TODO: (@ladislas) move to UtilsKit
extension String {
    var isRasterImageFile: Bool {
        ["png", "jpg", "jpeg"].contains(self.pathExtension)
    }

    var isVectorImageFile: Bool {
        self.pathExtension == "svg"
    }
}

// MARK: - l10n.ChoiceImageView

extension l10n {
    enum ChoiceImageView {
        static let imageUnknownError = LocalizedStringInterpolation("game_engine_kit.choice_image_view.image_unknown_error",
                                                                    bundle: GameEngineKitResources.bundle,
                                                                    value: "❌\nImage not found:\n%s",
                                                                    comment: "ChoiceImageView image unknown error")
    }
}

#Preview {
    let pngImagePathFromContentKit = Bundle.path(forImage: "discover_leka.activity.icon", in: ContentKitResources.bundle)!
    let pngImagePath = Bundle.path(forImage: "image-placeholder-png-boy_sleeping")!
    let jpgImagePath = Bundle.path(forImage: "image-placeholder-jpg-boy_sleeping")!
    let svgImagePath = Bundle.path(forImage: "image-placeholder-svg-boy_sleeping")!

    return ScrollView {
        VStack(spacing: 60) {
            HStack(spacing: 70) {
                VStack {
                    Text("PNG")
                        .font(.largeTitle)
                    Text("ContentKit")
                        .font(.caption)
                }
                ChoiceImageView(image: pngImagePathFromContentKit, size: 200, state: .idle)
                ChoiceImageView(image: pngImagePathFromContentKit, size: 200, state: .rightAnswer)
                ChoiceImageView(image: pngImagePathFromContentKit, size: 200, state: .wrongAnswer)
            }

            HStack(spacing: 70) {
                Text("PNG")
                    .font(.largeTitle)
                ChoiceImageView(image: pngImagePath, size: 200, state: .idle)
                ChoiceImageView(image: pngImagePath, size: 200, state: .rightAnswer)
                ChoiceImageView(image: pngImagePath, size: 200, state: .wrongAnswer)
            }

            HStack(spacing: 70) {
                Text("JPG")
                    .font(.largeTitle)
                ChoiceImageView(image: jpgImagePath, size: 200, state: .idle)
                ChoiceImageView(image: jpgImagePath, size: 200, state: .rightAnswer)
                ChoiceImageView(image: jpgImagePath, size: 200, state: .wrongAnswer)
            }

            HStack(spacing: 70) {
                Text("SVG")
                    .font(.largeTitle)
                ChoiceImageView(image: svgImagePath, size: 200, state: .idle)
                ChoiceImageView(image: svgImagePath, size: 200, state: .rightAnswer)
                ChoiceImageView(image: svgImagePath, size: 200, state: .wrongAnswer)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    .background(.lkBackground)
}
