// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension MelodyView {

    struct PlayMelodyModalView: View {
        @State private var isMelodyPlaying: Bool = false
        @Binding var showModal: Bool
        let viewModel: ViewModel
        let textStartMelody: String
        let textSkipMelody: String
        let action: () -> Void
        let kOverLayScaleFactor = 1.05
        let iconFrameSize: CGFloat = 200

        var body: some View {
            VStack {
                if isMelodyPlaying {
                    GameEngineKitAsset.Exercises.Melody.iconLekaSinging.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconFrameSize)
                        .overlay {
                            Circle()
                                .trim(from: 0, to: viewModel.progress)
                                .stroke(
                                    DesignKitAsset.Colors.btnDarkBlue.swiftUIColor,
                                    style: StrokeStyle(
                                        lineWidth: 6,
                                        lineCap: .round,
                                        lineJoin: .round,
                                        miterLimit: 10
                                    )
                                )
                                .frame(
                                    width: iconFrameSize * kOverLayScaleFactor,
                                    height: iconFrameSize * kOverLayScaleFactor
                                )
                        }

                } else {
                    GameEngineKitAsset.Exercises.Melody.iconLekaSinging.swiftUIImage
                        .resizable()
                        .scaledToFit()
                    Text(textStartMelody)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 15) {
                        Button {
                            showModal = false
                            viewModel.startActivity()
                        } label: {
                            Text(textSkipMelody)
                                .font(.body)
                                .foregroundStyle(DesignKitAsset.Colors.btnDarkBlue.swiftUIColor)
                                .frame(width: 210, height: 45)
                                .background {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(
                                            DesignKitAsset.Colors.btnDarkBlue.swiftUIColor.opacity(0.4),
                                            lineWidth: 2)
                                }
                        }

                        Button {
                            action()
                            isMelodyPlaying = true
                        } label: {
                            Image(systemName: "play.circle")
                                .frame(width: 210, height: 45)
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                                .background {
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(DesignKitAsset.Colors.btnDarkBlue.swiftUIColor)
                                }
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
            .frame(width: 800, height: 350)
        }
    }
}

#Preview {
    let viewModel = MelodyView.ViewModel(
        midiPlayer: MIDIPlayer(instrument: .xylophone), selectedSong: MidiRecording(.aGreenMouse))

    return MelodyView.PlayMelodyModalView(
        showModal: .constant(true), viewModel: viewModel,
        textStartMelody: "Appuie sur le bouton 'Play' \n pour écouter et voir Leka jouer de la musique!",
        textSkipMelody: "Passer la chanson"
    ) {
        print("Melody triggered")
    }
}
