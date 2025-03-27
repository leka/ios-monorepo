// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SVGView
import SwiftUI

// MARK: - AnimatableBlur

struct AnimatableBlur: AnimatableModifier {
    var blurRadius: CGFloat

    var animatableData: CGFloat {
        get { self.blurRadius }
        set { self.blurRadius = newValue }
    }

    func body(content: Content) -> some View {
        content
            .blur(radius: self.blurRadius)
    }
}

// MARK: - AnimatableSaturation

struct AnimatableSaturation: AnimatableModifier {
    var saturation: Double

    var animatableData: Double {
        get { self.saturation }
        set { self.saturation = newValue }
    }

    func body(content: Content) -> some View {
        content
            .saturation(self.saturation)
    }
}

// MARK: - ActionButtonObserve

struct ActionButtonObserve: View {
    // MARK: Lifecycle

    init(image: String, imageWasTapped: Binding<Bool>) {
        if let imagePath = Bundle.path(forImage: image) {
            self.image = imagePath
            self.isSFSymbol = false
        } else if UIImage(systemName: image) != nil {
            self.image = image
            self.isSFSymbol = true
        } else {
            fatalError("Image not found: \(image)")
        }

        self._imageWasTapped = imageWasTapped
    }

    // MARK: Internal

    @Binding var imageWasTapped: Bool

    let image: String
    let isSFSymbol: Bool

    var body: some View {
        Button {
            withAnimation {
                self.imageWasTapped = true
            }
        } label: {
            Button(String(l10n.ActionButtonObserve.buttonLabel.characters)) {}
                .font(.title)
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .allowsHitTesting(false)
                .transition(.opacity)
                .opacity(self.imageWasTapped ? 0 : 1)
                .frame(width: 460, height: 460)
                .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(self.imageWasTapped)
        .background {
            if self.isSFSymbol {
                Image(systemName: self.image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .padding(60)
                    .frame(width: 460, height: 460)
                    .foregroundStyle(.black)
                    .background(self.choiceBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                    .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
            } else {
                if !FileManager.default.fileExists(atPath: self.image) {
                    self.imageNotFound()
                }

                if self.image.isRasterImageFile {
                    Image(uiImage: UIImage(named: self.image)!)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .scaledToFit()
                        .frame(width: 460, height: 460)
                        .background(self.choiceBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                        .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
                }

                if self.image.isVectorImageFile {
                    SVGView(contentsOf: URL(fileURLWithPath: self.image))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 460, height: 460)
                        .background(self.choiceBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                        .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
                }
            }
        }
    }

    // MARK: Private

    private let choiceBackgroundColor: Color = .init(
        light: .white,
        dark: UIColor(displayP3Red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1.0)
    )

    private func imageNotFound() -> some View {
        Text("Image not found: \(self.image)")
            .multilineTextAlignment(.center)
            .frame(
                width: 460,
                height: 460
            )
            .background(self.choiceBackgroundColor)
            .overlay {
                Circle()
                    .stroke(Color.red, lineWidth: 5)
            }
            .onAppear {
                logGEK.error("Image not found: \(self.image)")
            }
    }
}

// MARK: - l10n.ActionButtonObserve

extension l10n {
    enum ActionButtonObserve {
        static let buttonLabel = LocalizedString("game_engine_kit.action_button_observe.button_label",
                                                 bundle: ContentKitResources.bundle,
                                                 value: "Tap to reveal",
                                                 comment: "ActionButtonObserve button label")

        static let imageUnknownError = LocalizedStringInterpolation("game_engine_kit.action_button_observe.image_unknown_error",
                                                                    bundle: ContentKitResources.bundle,
                                                                    value: "❌\nImage not found:\n%1$@",
                                                                    comment: "ActionButtonObserve button label")
    }
}

#Preview {
    ScrollView {
        VStack {
            HStack {
                ActionButtonObserve(
                    image: "4.circle", imageWasTapped: .constant(false)
                )
                ActionButtonObserve(
                    image: "4.circle", imageWasTapped: .constant(true)
                )
            }
            HStack {
                ActionButtonObserve(
                    image: "pictograms-foods-fruits-banana_yellow-00FB", imageWasTapped: .constant(false)
                )
                ActionButtonObserve(
                    image: "pictograms-foods-fruits-banana_yellow-00FB", imageWasTapped: .constant(true)
                )
            }
        }
    }
}
