// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

enum DanceFreeze {
    // MARK: Public

    public struct MainView: View {
        // MARK: Lifecycle

        public init(songs: [AudioRecording]) {
            self.songs = songs
            _viewModel = StateObject(wrappedValue: MainViewViewModel(songs: songs))
        }

        public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
            guard let payload = exercise.payload as? AudioRecordingPlayer.Payload else {
                fatalError("Exercise payload is not .selection")
            }

            self.songs = payload.songs
            _viewModel = StateObject(
                wrappedValue: MainViewViewModel(
                    songs: payload.songs, shared: data))
        }

        // MARK: Public

        public var body: some View {
            NavigationStack {
                switch mode {
                    case .waitingForSelection:
                        LauncherView(viewModel: viewModel, mode: $mode, motion: $motion)
                    case .automaticMode:
                        PlayerView(viewModel: viewModel, isAuto: true, motion: motion)
                            .onDisappear {
                                viewModel.setAudioRecording(
                                    audioRecording: AudioRecording(name: "", file: ""))
                                viewModel.completeDanceFreeze()
                            }
                    case .manualMode:
                        PlayerView(viewModel: viewModel, isAuto: false, motion: motion)
                            .onDisappear {
                                viewModel.setAudioRecording(
                                    audioRecording: AudioRecording(name: "", file: ""))
                                viewModel.completeDanceFreeze()
                            }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }

        // MARK: Internal

        let songs: [AudioRecording]

        // MARK: Private

        @State private var mode = Stage.waitingForSelection
        @State private var motion: Motion = .rotation
        @StateObject private var viewModel: MainViewViewModel
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

    return DanceFreeze.MainView(songs: songs)
}
