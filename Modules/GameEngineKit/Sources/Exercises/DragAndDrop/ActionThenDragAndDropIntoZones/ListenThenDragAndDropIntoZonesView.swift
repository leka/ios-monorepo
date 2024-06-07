// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ListenThenDragAndDropIntoZonesView: View {
    // MARK: Lifecycle

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard case let .ipad(type: .audio(name)) = exercise.action else {
            log.error("Exercise payload is not .dragAndDrop and/or Exercise does not contain iPad audio action")
            fatalError("💥 Exercise payload is not .dragAndDrop and/or Exercise does not contain iPad audio action")
        }

        self.exercise = exercise
        self.exerciseSharedData = data

        _audioPlayer = StateObject(wrappedValue: AudioPlayerViewModel(player: AudioPlayer(audioRecording: name)))
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            ActionButtonListen(audioPlayer: self.audioPlayer)
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
}
