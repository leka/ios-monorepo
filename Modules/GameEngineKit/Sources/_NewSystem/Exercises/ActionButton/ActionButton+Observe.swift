// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
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
                    Text("Tap to reveal")
                        // TODO: (@ui/ux) - Design System - replace with Leka font
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
            Text("❌\nImage not found:\n\(self.image)")
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
