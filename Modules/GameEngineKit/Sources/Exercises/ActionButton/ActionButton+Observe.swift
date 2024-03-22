// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
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
    let image: String

    @Binding var imageWasTapped: Bool

    var body: some View {
        if let uiImage = UIImage(named: image) {
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
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 460, height: 460)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .modifier(AnimatableBlur(blurRadius: self.imageWasTapped ? 0 : 20))
                    .modifier(AnimatableSaturation(saturation: self.imageWasTapped ? 1 : 0))
            }
        } else {
            Text(l10n.ActionButtonObserve.imageUnknownError(self.image))
                .multilineTextAlignment(.center)
                .overlay {
                    Circle()
                        .stroke(Color.red, lineWidth: 5)
                }
                .frame(
                    width: 460,
                    height: 460
                )
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
