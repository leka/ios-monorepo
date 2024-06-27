// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ListenThenDragAndDropIntoZonesView: View {
    // MARK: Lifecycle

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        self.exercise = exercise
        self.exerciseSharedData = data

        switch exercise.action {
            case let .ipad(type: .audio(name)):
                log.debug("Audio name: \(name)")
                self.audioData = name
                AudioPlayer.shared.setAudioData(data: self.audioData)
                _audioPlayer = StateObject(wrappedValue: AudioPlayerViewModel(player: AudioPlayer.shared))
            case let .ipad(type: .speech(utterance)):
                log.debug("Speech utterance: \(utterance)")
                self.audioData = utterance
                SpeechSynthesizer.shared.setAudioData(data: self.audioData)
                _audioPlayer = StateObject(wrappedValue: AudioPlayerViewModel(player: SpeechSynthesizer.shared))
            default:
                log.error("Action not recognized: \(String(describing: exercise.action))")
                fatalError("💥 Action not recognized: \(String(describing: exercise.action))")
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            ActionButtonListen(audioPlayer: self.audioPlayer, audioData: self.audioData)
                .padding(20)

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            DragAndDropIntoZonesView(
                exercise: self.exercise,
                data: self.exerciseSharedData
            )
            .animation(.easeOut(duration: 0.3), value: self.audioPlayer.state == .finishedPlaying)
            .grayscale(self.audioPlayer.state == .finishedPlaying ? 0.0 : 1.0)
            .allowsHitTesting(self.audioPlayer.state == .finishedPlaying)

            Spacer()
        }
    }

    // MARK: Private

    private var exercise: Exercise
    private var exerciseSharedData: ExerciseSharedData?
    @StateObject private var audioPlayer: AudioPlayerViewModel
    private let audioData: String
}
