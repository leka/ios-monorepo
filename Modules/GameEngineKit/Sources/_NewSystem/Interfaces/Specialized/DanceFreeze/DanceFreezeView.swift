// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

public struct DanceFreezeView: View {
    // MARK: Lifecycle

    public init(songs: [DanceFreeze.Song]) {
        self.songs = songs
        self.selectedAudioRecording = songs.first!
        self.data = nil
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        guard let payload = exercise.payload as? DanceFreeze.Payload else {
            fatalError("Exercise payload is not DanceFreeze.Payload")
        }

        self.songs = payload.songs
        self.selectedAudioRecording = self.songs.first!
        self.data = data
    }

    // MARK: Public

    public var body: some View {
        switch self.mode {
            case .waitingForSelection:
                LauncherView(mode: self.$mode,
                             motion: self.$motion,
                             selectedAudioRecording: self.$selectedAudioRecording,
                             songs: self.songs)
            case .automaticMode:
                PlayerView(selectedAudioRecording: self.selectedAudioRecording, isAuto: true, motion: self.motion, data: self.data)
            case .manualMode:
                PlayerView(selectedAudioRecording: self.selectedAudioRecording, isAuto: false, motion: self.motion, data: self.data)
        }
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

    @State private var mode = Stage.waitingForSelection
    @State private var motion: Motion = .rotation
    @State private var selectedAudioRecording: DanceFreeze.Song

    private let data: ExerciseSharedData?
    private let songs: [DanceFreeze.Song]
}

#Preview {
    DanceFreezeView(songs: [
        DanceFreeze.Song(song: "Giggly_Squirrel"),
        DanceFreeze.Song(song: "Empty_Page"),
        DanceFreeze.Song(song: "Early_Bird"),
        DanceFreeze.Song(song: "Hands_On"),
        DanceFreeze.Song(song: "In_The_Game"),
        DanceFreeze.Song(song: "Little_by_little"),
    ])
}
