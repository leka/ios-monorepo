// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - DanceFreezeStage

public enum DanceFreezeStage {
    case waitingForSelection
    case automaticMode
    case manualMode
}

// MARK: - NewDanceFreezeView

struct NewDanceFreezeView: View {
    // MARK: Lifecycle

    init(viewModel: NewDanceFreezeViewViewModel) {
        self.viewModel = viewModel
        self.selectedAudioRecording = viewModel.songs.first!
    }

    // MARK: Public

    public var body: some View {
        if self.stageMode == .waitingForSelection {
            VStack(spacing: 50) {
                Text(l10n.DanceFreezeView.instructions)
                    .font(.headline)
                    .padding(.top, 30)

                HStack(spacing: 30) {
                    VStack(spacing: 0) {
                        ContentKitAsset.Exercises.DanceFreeze.imageIllustration.swiftUIImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(80)
                        DanceFreezeMotionSelectorView(motion: self.$motion)
                    }

                    DanceFreezeSongSelectorView(
                        songs: self.viewModel.songs,
                        selectedAudioRecording: self.$selectedAudioRecording
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)

                HStack(spacing: 70) {
                    Button {
                        self.viewModel.setupDanceFreeze(
                            audio: .file(name: self.selectedAudioRecording.audio),
                            motion: self.motion,
                            stage: .manualMode
                        )
                        self.stageMode = .manualMode
                    } label: {
                        CapsuleColoredButtonLabel(String(l10n.DanceFreezeView.manualButtonLabel.characters), color: .cyan)
                    }

                    Button {
                        self.viewModel.setupDanceFreeze(
                            audio: .file(name: self.selectedAudioRecording.audio),
                            motion: self.motion,
                            stage: .automaticMode
                        )
                        self.stageMode = .automaticMode
                    } label: {
                        CapsuleColoredButtonLabel(String(l10n.DanceFreezeView.autoButtonLabel.characters), color: .mint)
                    }
                }
                .padding(.bottom, 30)
            }
        } else {
            VStack {
                ContinuousProgressBar(progress: self.viewModel.progress)
                    .padding(20)

                Button {
                    self.viewModel.onDanceFreezeToggle()
                } label: {
                    if self.viewModel.isDancing {
                        DanceLottieView()
                    } else {
                        FreezeLottieView()
                    }
                }
                .disabled(self.viewModel.isAuto)
            }
            .onAppear {
                self.viewModel.onDanceFreezeToggle()
            }
            .onDisappear {
                self.viewModel.completeDanceFreeze()
            }
        }
    }

    // MARK: Internal

    @State var motion: DanceFreezeMotion = .rotation
    @State var selectedAudioRecording: DanceFreezeSong
    @State var stageMode: DanceFreezeStage = .waitingForSelection

    // MARK: Private

    private var viewModel: NewDanceFreezeViewViewModel
}

#Preview {
    let songs = [
        DanceFreezeSong(song: "Giggly_Squirrel"),
        DanceFreezeSong(song: "Empty_Page"),
        DanceFreezeSong(song: "Early_Bird"),
        DanceFreezeSong(song: "Hands_On"),
        DanceFreezeSong(song: "In_The_Game"),
        DanceFreezeSong(song: "Little_by_little"),
    ]
    let coordinator = NewDanceFreezeCoordinator(songs: songs)
    let viewModel = NewDanceFreezeViewViewModel(coordinator: coordinator)

    return NewDanceFreezeView(viewModel: viewModel)
}
