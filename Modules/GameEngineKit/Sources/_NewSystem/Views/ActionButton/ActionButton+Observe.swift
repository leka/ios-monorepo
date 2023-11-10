// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActionObserveButton: View {
    let image: String
    @Binding var imageHasBeenObserved: Bool
    @State private var animationPercent: CGFloat = 0.0

    var body: some View {
        Button {
            withAnimation {
                imageHasBeenObserved = true
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
        .disabled(imageHasBeenObserved)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: imageHasBeenObserved ? 6 : 3, x: 0, y: 3
        )
        .animation(.bouncy, value: animationPercent)
    }
}

#Preview {

    struct ActionObserveButtonContainer: View {
        @State var imageHasBeenObserved = false
        var body: some View {
            ActionObserveButton(
                image: "placeholder-observe_then_touch_to_select", imageHasBeenObserved: $imageHasBeenObserved)
        }
    }

    return ActionObserveButtonContainer()

}
