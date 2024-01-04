// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

public struct DanceFreezeView: View {
    // MARK: Lifecycle

    public init(songs: [AudioRecording], instructions: DanceFreeze.Payload.Instructions) {
        self.songs = songs
        self.instructions = instructions
        self.selectedAudioRecording = songs.first!
        self.data = nil
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DanceFreeze.Payload else {
            fatalError("Exercise payload is not DanceFreeze.Payload")
        }

        self.songs = payload.songs
        self.instructions = payload.instructions
        self.selectedAudioRecording = self.songs.first!
        self.data = data
    }

    // MARK: Public

    public var body: some View {
        NavigationStack {
            switch self.mode {
                case .waitingForSelection:
                    LauncherView(mode: self.$mode,
                                 motion: self.$motion,
                                 selectedAudioRecording: self.$selectedAudioRecording,
                                 songs: self.songs,
                                 instructions: self.instructions)
                case .automaticMode:
                    PlayerView(selectedAudioRecording: self.selectedAudioRecording, isAuto: true, motion: self.motion)
                case .manualMode:
                    PlayerView(selectedAudioRecording: self.selectedAudioRecording, isAuto: false, motion: self.motion)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: Internal

    enum Stage {
        case waitingForSelection
        case automaticMode
        case manualMode
    }

    enum Motion {
        case rotation
        case movement
    }

    // MARK: Private

    private let data: ExerciseSharedData?
    private let songs: [AudioRecording]
    private let instructions: DanceFreeze.Payload.Instructions

    @State private var mode = Stage.waitingForSelection
    @State private var motion: Motion = .rotation
    @State private var selectedAudioRecording: AudioRecording
}

#Preview {
    let songs = [
        AudioRecording(name: "Giggly Squirrel", file: "Giggly_Squirrel"),
        AudioRecording(name: "Empty Page", file: "Empty_Page"),
        AudioRecording(name: "Early Bird", file: "Early_Bird"),
        AudioRecording(name: "Hands On", file: "Hands_On"),
        AudioRecording(name: "In The Game", file: "In_The_Game"),
        AudioRecording(name: "Little by Little", file: "Little_by_little"),
    ]
    let instructions = DanceFreeze.Payload.Instructions(
        textMainInstructions: "Danse avec Leka au rythme de la musique et fais la statue lorsqu'il s'arrête.",
        textMotionSelection: "Sélection du mouvement",
        textMusicSelection: "Sélection de la musique",
        textButtonRotation: "Rotation",
        textButtonMovement: "Mouvement",
        textButtonModeManual: "Jouer - Mode manuel",
        textButtonModeAuto: "Jouer - Mode auto"
    )

    return DanceFreezeView(songs: songs, instructions: instructions)
}
