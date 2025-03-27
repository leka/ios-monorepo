// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct ListenThenDragAndDropToAssociateView: View {
    // MARK: Lifecycle

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        self.exercise = exercise
        self.exerciseSharedData = data

        switch exercise.action {
            case let .ipad(type: .audio(name)):
                self.audioData = .file(name: name)
            case let .ipad(type: .speech(utterance)):
                self.audioData = .speech(text: utterance)
            default:
                logGEK.error("Action not recognized: \(String(describing: exercise.action))")
                fatalError("💥 Action not recognized: \(String(describing: exercise.action))")
        }
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            ActionButtonListen(audio: self.audioData)
                .padding(20)
                .simultaneousGesture(TapGesture().onEnded {
                    self.audioHasBeenPlayed = true
                })

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            DragAndDropToAssociateView(
                exercise: self.exercise,
                data: self.exerciseSharedData
            )
            .animation(.easeOut(duration: 0.3), value: self.audioHasBeenPlayed)
            .disabled(!self.audioHasBeenPlayed)
            .grayscale(self.audioHasBeenPlayed ? 0 : 1)
            .allowsHitTesting(self.audioHasBeenPlayed)

            Spacer()
        }
    }

    // MARK: Private

    @StateObject private var audioManagerViewModel = AudioManagerViewModel()
    @State private var audioHasBeenPlayed: Bool = false

    private var exercise: Exercise
    private var exerciseSharedData: ExerciseSharedData?
    private let audioData: AudioManager.AudioType
}
