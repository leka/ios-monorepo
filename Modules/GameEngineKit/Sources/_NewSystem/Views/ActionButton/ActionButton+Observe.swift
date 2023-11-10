// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActionButtonObserve: View {
    let image: String
    @Binding var imageWasTapped: Bool
    @State private var animationPercent: CGFloat = 0.0

    var body: some View {
        Button {
            withAnimation {
                imageWasTapped = true
                animationPercent = 1.0
            }
        } label: {
            if let uiImage = UIImage(named: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .overlay {
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.6), Color.black.opacity(0.9), Color.black.opacity(1),
                            ]),
                            center: .center,
                            startRadius: 50,
                            endRadius: 300
                        )
                        .opacity(1 - animationPercent)

                        VStack {
                            Image(systemName: "hand.tap")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            Text("Tap to reveal")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .opacity(1 - animationPercent)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .frame(
                        width: 460,
                        height: 460
                    )

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
        .disabled(imageWasTapped)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: imageWasTapped ? 6 : 3, x: 0, y: 3
        )
        .animation(.bouncy, value: animationPercent)
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
