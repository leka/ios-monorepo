// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ExerciseInstructionsButton

struct ExerciseInstructionsButton: View {
    @StateObject var speaker = AudioPlayerViewModel(player: SpeechSynthesizer())
    @State var instructions: String

    var body: some View {
        Button(self.instructions.trimmingCharacters(in: .whitespacesAndNewlines)) {
            self.speaker.setAudioData(data: self.instructions)
            self.speaker.play()
        }
        .buttonStyle(StepInstructions_ButtonStyle(state: self.speaker.state))
    }
}

// MARK: - StepInstructions_ButtonStyle

struct StepInstructions_ButtonStyle: ButtonStyle {
    // MARK: Internal

    let state: AudioPlayerState

    func makeBody(configuration: Self.Configuration) -> some View {
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
        .background(self.backgroundGradient)
        .overlay(self.buttonStroke)
        .overlay(self.speachIndicator)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 10,
                style: .circular
            )
        )
        .shadow(
            color: .black.opacity(0.1),
            radius: self.state == .playing ? 0 : 4, x: 0, y: self.state == .playing ? 1 : 4
        )
        .scaleEffect(self.state == .playing ? 0.98 : 1)
        .disabled(self.state == .playing)
        .animation(.easeOut(duration: 0.2), value: self.state == .playing)
    }

    // MARK: Private

    private var backgroundGradient: some View {
        ZStack {
            Color.white
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.0), .black.opacity(0.0)]),
                startPoint: .top, endPoint: .center
            )
            .opacity(self.state == .playing ? 1 : 0)
        }
    }

    private var buttonStroke: some View {
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
        .opacity(self.state == .playing ? 0.5 : 0)
    }

    private var speachIndicator: some View {
        HStack {
            Spacer()
            DesignKitAsset.Images.personTalking.swiftUIImage
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(
                    self.state == .playing
                        ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor : DesignKitAsset.Colors.darkGray.swiftUIColor
                )
                .padding(10)
        }
    }
}
