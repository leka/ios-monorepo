// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

public let kAvailableSongsDeprecated: [AudioRecordingModelDeprecated] = [
    AudioRecordingModelDeprecated(name: "Giggly Squirrel", file: "Giggly_Squirrel"),
    AudioRecordingModelDeprecated(name: "Empty Page", file: "Empty_Page"),
    AudioRecordingModelDeprecated(name: "Early Bird", file: "Early_Bird"),
    AudioRecordingModelDeprecated(name: "Hands On", file: "Hands_On"),
    AudioRecordingModelDeprecated(name: "In The Game", file: "In_The_Game"),
    AudioRecordingModelDeprecated(name: "Little by Little", file: "Little_by_little"),
]

struct SongSelectorDeprecated: View {
    @EnvironmentObject private var viewModel: DanceFreezeViewModelDeprecated
    @State private var selectedAudioRecording: AudioRecordingModelDeprecated = kAvailableSongsDeprecated.first!

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
                    ForEach(kAvailableSongsDeprecated, id: \.self) { audioRecording in
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
            viewModel.setAudioRecording(audioRecording: kAvailableSongsDeprecated[0])
        }
    }
}
