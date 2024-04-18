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
        if let path = Bundle.path(forImage: image) {
            log.debug("Image found at path: \(path)")
            self.image = path
        } else {
            log.error("Image not found: \(image)")
            self.image = image
        }
        self._imageWasTapped = imageWasTapped
    }

    // MARK: Internal

    let image: String

    @Binding var imageWasTapped: Bool

    var body: some View {
        Button {
            withAnimation {
                self.imageWasTapped = true
            }
        } label: {
            VStack {
                Image(systemName: "hand.tap")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
                Text(l10n.ActionButtonObserve.buttonLabel)
                    .font(.title)
                    .foregroundColor(.white)
            }
            .transition(.opacity)
            .opacity(self.imageWasTapped ? 0 : 1)
            .frame(width: 460, height: 460)
            .contentShape(RoundedRectangle(cornerRadius: 10))
        }
        .disabled(self.imageWasTapped)
        .background {
            if !FileManager.default.fileExists(atPath: self.image) {
                self.imageNotFound()
            }

            if self.image.isRasterImageFile {
                Image(uiImage: UIImage(named: self.image)!)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .frame(width: 460, height: 460)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                    .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
            }

            if self.image.isVectorImageFile {
                SVGView(contentsOf: URL(fileURLWithPath: self.image))
                    .frame(width: 460, height: 460)
                    .background(self.choiceBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                    .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
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
                log.error("Image not found: \(self.image)")
            }
    }
}

// MARK: - l10n.ActionButtonObserve

extension l10n {
    enum ActionButtonObserve {
        static let buttonLabel = LocalizedString("game_engine_kit.action_button_observe.button_label",
                                                 bundle: GameEngineKitResources.bundle,
                                                 value: "Tap to reveal",
                                                 comment: "ActionButtonObserve button label")

        static let imageUnknownError = LocalizedStringInterpolation("game_engine_kit.action_button_observe.image_unknown_error",
                                                                    bundle: GameEngineKitResources.bundle,
                                                                    value: "❌\nImage not found:\n%1$@",
                                                                    comment: "ActionButtonObserve button label")
    }
}

#Preview {
    struct ActionObserveButtonContainer: View {
        @State var imageWasTapped = false
        var body: some View {
            ActionButtonObserve(
                image: "placeholder-observe_then_touch_to_select", imageWasTapped: $imageWasTapped
            )
        }
    }

    return ActionObserveButtonContainer()
}
