// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ExerciseInstructionsButton

struct ExerciseInstructionsButton: View {
    // MARK: Lifecycle

    init(instructions: String) {
        self.instructions = .speech(text: instructions)
    }

    // MARK: Internal

    var body: some View {
        Button(self.instructions.value.trimmingCharacters(in: .whitespacesAndNewlines)) {
            self.audioManager.play(self.instructions)
        }
        .buttonStyle(self.buttonStyle)
    }

    // MARK: Private

    @StateObject private var audioManagerViewModel = AudioManagerViewModel()

    private let audioManager = AudioManager.shared
    private let instructions: AudioManager.AudioType

    private var buttonStyle: AnyButtonStyle {
        var backgroundGradient: some View {
            ZStack {
                Color.white
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.0), .black.opacity(0.0)]),
                    startPoint: .top, endPoint: .center
                )
                .opacity(self.isPlaying ? 1 : 0)
            }
        }

        var buttonStroke: some View {
            RoundedRectangle(
                cornerRadius: 10,
                style: .circular
            )
            .fill(
                .clear,
                strokeBorder: LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.05)]),
                    startPoint: .bottom,
                    endPoint: .top
                ),
                lineWidth: 4
            )
            .opacity(self.isPlaying ? 0.5 : 0)
        }

        var speachIndicator: some View {
            HStack {
                Spacer()
                DesignKitAsset.Images.personTalking.swiftUIImage
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(
                        self.isPlaying
                            ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : DesignKitAsset.Colors.darkGray.swiftUIColor
                    )
                    .padding(10)
            }
        }

        return AnyButtonStyle { configuration in
            AnyView(
                HStack(spacing: 0) {
                    Spacer()
                    configuration.label
                        .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
                        .font(.system(size: 22, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 85)
                    Spacer()
                }
                .frame(maxWidth: 640)
                .frame(height: 85, alignment: .center)
                .background(backgroundGradient)
                .overlay(buttonStroke)
                .overlay(speachIndicator)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .circular
                    )
                )
                .shadow(
                    color: .black.opacity(0.1),
                    radius: self.isPlaying ? 0 : 4, x: 0, y: self.isPlaying ? 1 : 4
                )
                .scaleEffect(self.isPlaying ? 0.98 : 1)
                .disabled(self.isPlaying)
                .animation(.easeOut(duration: 0.2), value: self.isPlaying)
            )
        }
    }

    private var isPlaying: Bool {
        if case let .playing(audio) = self.audioManagerViewModel.state, audio == self.instructions {
            true
        } else {
            false
        }
    }
}

#Preview {
    ExerciseInstructionsButton(instructions: "Instructions")
}
