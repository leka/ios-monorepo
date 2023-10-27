// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct Media_ButtonStyle: ButtonStyle {
    var progress: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .mask(Circle().inset(by: 4))
            .background(
                Circle()
                    .fill(
                        Color.white, strokeBorder: DesignKitAsset.Colors.gameButtonBorder.swiftUIColor,
                        lineWidth: 4
                    )
                    .overlay(
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 0.2), value: progress)
                    )
            )
            .contentShape(Circle())
    }
}

struct ListenButton: View {
    @ObservedObject var audioPlayer: AudioPlayer

    var body: some View {
        Button {
            audioPlayer.play()
        } label: {
            Image(systemName: "speaker.2")
                .font(.system(size: 100, weight: .medium))
                .foregroundColor(.accentColor)
                .padding(40)
        }
        .frame(width: 200)
        .disabled(audioPlayer.isPlaying)
        .buttonStyle(Media_ButtonStyle(progress: audioPlayer.progress))
        .scaleEffect(audioPlayer.isPlaying ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: audioPlayer.isPlaying ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: audioPlayer.isPlaying)
    }
}

struct ObserveButton: View {
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
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(
                        width: 200,
                        height: 200
                    )
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0.7), Color.black.opacity(0.3), Color.black.opacity(0.7),
                            ]), startPoint: .top, endPoint: .bottom
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
            } else {
                Text("❌\nImage not found:\n\(image)")
                    .multilineTextAlignment(.center)
                    .overlay {
                        Circle()
                            .stroke(Color.red, lineWidth: 5)
                    }
                    .frame(
                        width: 200,
                        height: 200
                    )
            }
        }
        .disabled(imageHasBeenObserved)
        .buttonStyle(Media_ButtonStyle(progress: animationPercent))
        .scaleEffect(imageHasBeenObserved ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: .accentColor.opacity(0.2),
            radius: imageHasBeenObserved ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 1, dampingFraction: 0.45), value: imageHasBeenObserved)
    }
}
