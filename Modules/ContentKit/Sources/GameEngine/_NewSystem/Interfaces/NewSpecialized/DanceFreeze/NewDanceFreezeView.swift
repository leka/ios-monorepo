// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - NewDanceFreezeView

struct NewDanceFreezeView: View {
    // MARK: Lifecycle

    init(viewModel: NewDanceFreezeViewViewModel) {
        self.viewModel = viewModel
        self.selectedAudioRecording = viewModel.songs.first!
    }

    // MARK: Public

    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    self.isMusicSelectorPresented = true
                    self.viewModel.pause()
                } label: {
                    Label(String(l10n.NewDanceFreezeView.changeMusicButtonLabel.characters), systemImage: "music.quarternote.3")
                }
                .padding(20)
                .background(Capsule().fill(.background).shadow(radius: 3))

                Toggle(isOn: self.$isMovementEnabled) {
                    HStack(alignment: .center) {
                        ContentKitAsset.Exercises.DanceFreeze.iconMotionModeMovement.swiftUIImage
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(l10n.NewDanceFreezeView.movementToggleLabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Toggle(isOn: self.$isAuto) {
                    HStack(alignment: .center) {
                        Image(uiImage: UIImage(named: "touch_to_select.gesture.icon.png", in: .module, with: nil)!)
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text(l10n.NewDanceFreezeView.automaticToggleLabel)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.horizontal, 200)

            ContinuousProgressBar(progress: self.viewModel.progress)
                .padding(20)

            Button {
                self.viewModel.onSwitchDanceState()
            } label: {
                if self.viewModel.isDancing {
                    DanceLottieView()
                } else {
                    FreezeLottieView()
                }
            }
            .disabled(self.isAuto)
        }
        .onChange(of: self.isAuto) {
            self.viewModel.updateAutoMode(isAuto: self.isAuto)
        }
        .onChange(of: self.isMovementEnabled) {
            self.viewModel.updateMotionMode(isMovementEnabled: self.isMovementEnabled)
        }
        .sheet(isPresented: self.$isMusicSelectorPresented) {
            DanceFreezeSongSelectorView(
                songs: self.viewModel.songs,
                selectedAudioRecording: self.$selectedAudioRecording
            )
            .onDisappear {
                self.viewModel.setup(audio: .file(name: self.selectedAudioRecording.audio), isAuto: self.isAuto)
                self.viewModel.onSwitchDanceState()
            }
        }
        .onDisappear {
            self.viewModel.complete()
        }
    }

    // MARK: Private

    @State private var isAuto: Bool = false
    @State private var isMovementEnabled: Bool = false
    @State private var isMusicSelectorPresented: Bool = true
    @State private var selectedAudioRecording: DanceFreezeSong

    private var viewModel: NewDanceFreezeViewViewModel
}

// MARK: - l10n.NewDanceFreezeView

extension l10n {
    enum NewDanceFreezeView {
        static let changeMusicButtonLabel = LocalizedString("game_engine_kit.new_dance_freeze_view.change_music_button_label",
                                                            bundle: ContentKitResources.bundle,
                                                            value: "Change music",
                                                            comment: "Label of button that changes music in DanceFreeze")

        static let movementToggleLabel = LocalizedString("game_engine_kit.new_dance_freeze_view.movement_toggle_label",
                                                         bundle: ContentKitResources.bundle,
                                                         value: "Movement",
                                                         comment: "Label of toggle that switch on/off movement in DanceFreeze")

        static let automaticToggleLabel = LocalizedString("game_engine_kit.new_dance_freeze_view.automatic_toggle_label",
                                                          bundle: ContentKitResources.bundle,
                                                          value: "Automatic",
                                                          comment: "Label of toggle that switch on/off mode in DanceFreeze")
    }
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
