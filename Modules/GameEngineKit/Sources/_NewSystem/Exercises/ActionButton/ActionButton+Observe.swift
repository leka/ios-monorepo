// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct AnimatableBlur: AnimatableModifier {
    var blurRadius: CGFloat

    var animatableData: CGFloat {
        get { blurRadius }
        set { blurRadius = newValue }
    }

    func body(content: Content) -> some View {
        content
            .blur(radius: blurRadius)
    }
}

struct AnimatableSaturation: AnimatableModifier {
    var saturation: Double

    var animatableData: Double {
        get { saturation }
        set { saturation = newValue }
    }

    func body(content: Content) -> some View {
        content
            .saturation(saturation)
    }
}

struct ActionButtonObserve: View {
    let image: String

    @Binding var imageWasTapped: Bool

    var body: some View {
        if let uiImage = UIImage(named: image) {
            Button {
                withAnimation {
                    imageWasTapped = true
                }
            } label: {
                VStack {
                    Image(systemName: "hand.tap")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.white)
                    Text("Tap to reveal")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .transition(.opacity)
                .opacity(imageWasTapped ? 0 : 1)
                .frame(width: 460, height: 460)
                .contentShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(imageWasTapped)
            .background {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 460, height: 460)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .modifier(AnimatableBlur(blurRadius: imageWasTapped ? 0 : 20))
                    .modifier(AnimatableSaturation(saturation: imageWasTapped ? 1 : 0))
            }
        } else {
            Text("❌\nImage not found:\n\(image)")
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
                image: "placeholder-observe_then_touch_to_select", imageWasTapped: $imageWasTapped)
        }
    }

    return ActionObserveButtonContainer()
}
