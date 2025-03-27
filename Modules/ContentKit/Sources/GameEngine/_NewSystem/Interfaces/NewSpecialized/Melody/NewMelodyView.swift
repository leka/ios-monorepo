// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit
import LocalizationKit
import SwiftUI

// MARK: - MelodyKeyboardType

enum MelodyKeyboardType {
    case full
    case partial
}

// MARK: - NewMelodyView

public struct NewMelodyView: View {
    // MARK: Public

    public var body: some View {
        NavigationStack {
            if !self.isMelodySetup {
                VStack(spacing: 50) {
                    HStack(spacing: 30) {
                        VStack(spacing: 20) {
                            ContentKitAsset.Exercises.Melody.imageIllustration.swiftUIImage
                                .resizable()
                                .aspectRatio(contentMode: .fit)

                            MelodyKeyboardModeView(keyboard: self.$viewModel.keyboardMode)
                        }

                        MelodySongSelectorView(songs: self.viewModel.songs, selectedMidiRecording: self.$viewModel.selectedSong)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(20)

                    Button {
                        self.viewModel.setupMelody()
                        self.isMelodySetup = true
                    } label: {
                        CapsuleColoredButtonLabel(String(l10n.MelodyView.playButtonLabel.characters), color: .cyan)
                    }
                }
            } else {
                switch self.viewModel.instrument {
                    case .xylophone:
                        MelodyXylophoneView(viewModel: self.viewModel)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: Internal

    @State var viewModel: NewMelodyViewViewModel

    // MARK: Private

    @State private var isMelodySetup: Bool = false
}

#Preview {
    let song = MidiRecordingPlayerSong(song: "Under_The_Moonlight")

    let coordinator = NewMelodyCoordinator(instrument: .xylophone, songs: [song])
    let viewModel = NewMelodyViewViewModel(coordinator: coordinator)
    return NewMelodyView(viewModel: viewModel)
}
