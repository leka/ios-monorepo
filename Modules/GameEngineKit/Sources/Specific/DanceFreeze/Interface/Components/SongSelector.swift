// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

public let kAvailableSongs: [AudioRecordingModel] = [
    // TO DO : (@hugo) Replace nyan by validated free use music
    AudioRecordingModel(name: "Frère Jacques", file: "nyan"),
    AudioRecordingModel(name: "Dansons la Capucine", file: "nyan"),
    AudioRecordingModel(name: "Petit Escargot", file: "nyan"),
    AudioRecordingModel(name: "Stairway to Heaven", file: "nyan"),
    AudioRecordingModel(name: "Can you feel the love tonight", file: "nyan"),
    AudioRecordingModel(name: "Cette année là", file: "nyan"),
]

struct SongSelector: View {
    @EnvironmentObject private var viewModel: DanceFreezeViewModel
    @State private var selectedAudioRecording: AudioRecordingModel = kAvailableSongs.first!

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {

        VStack {
            HStack {
                Image(systemName: "music.note.list")
                Text("Sélection de la musique :")
            }

            Divider()

            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20) {
                    ForEach(kAvailableSongs, id: \.self) { audioRecording in
                        Button {
                            selectedAudioRecording = audioRecording
                            viewModel.setAudioRecording(audioRecording: selectedAudioRecording)
                        } label: {
                            HStack {
                                Image(
                                    systemName: audioRecording == selectedAudioRecording
                                        ? "checkmark.circle.fill" : "circle"
                                )
                                .imageScale(.large)
                                .foregroundColor(
                                    audioRecording == selectedAudioRecording
                                        ? .green : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
                                )
                                Text(audioRecording.name)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(.white)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .onAppear {
            viewModel.setAudioRecording(audioRecording: kAvailableSongs[0])
        }
    }
}
