// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension MelodyView {

    struct PlayMelodyModalView: View {
        @Binding var progress: CGFloat
        let kOverLayScaleFactor = 1.05
        let iconFrameSize: CGFloat = 200

        var body: some View {
            VStack {
                GameEngineKitAsset.Exercises.Melody.iconLekaSinging.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconFrameSize)
                    .overlay {
                        Circle()
                            .trim(from: 0, to: progress)
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
            }
            .frame(width: 800, height: 350)
        }
    }
}

#Preview {
    let viewModel = MelodyView.ViewModel(
        midiPlayer: MIDIPlayer(instrument: .xylophone), selectedSong: MidiRecording(.aGreenMouse))

    return MelodyView.PlayMelodyModalView(progress: .constant(90))
}
