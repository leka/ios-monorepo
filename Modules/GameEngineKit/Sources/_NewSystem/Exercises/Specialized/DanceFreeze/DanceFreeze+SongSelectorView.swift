// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension DanceFreeze {
    struct SongSelectorView: View {
        // MARK: Lifecycle

        init(viewModel: MainViewViewModel) {
            self.viewModel = viewModel
            self.selectedAudioRecording = viewModel.songs.first!
        }

        // MARK: Internal

        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "music.note.list")
                    Text("Sélection de la musique")
                    Image(systemName: "music.note.list")
                }

                Divider()

                ScrollView {
                    LazyVGrid(columns: self.columns, alignment: .listRowSeparatorLeading, spacing: 20) {
                        ForEach(self.viewModel.songs, id: \.self) { audioRecording in
                            Button {
                                self.selectedAudioRecording = audioRecording
                                self.viewModel.setAudioRecording(audioRecording: self.selectedAudioRecording)
                            } label: {
                                HStack {
                                    Image(
                                        systemName: audioRecording == self.selectedAudioRecording
                                            ? "checkmark.circle.fill" : "circle"
                                    )
                                    .imageScale(.large)
                                    .foregroundColor(
                                        audioRecording == self.selectedAudioRecording
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
            .padding(.vertical, 15)
            .padding(.horizontal, 50)
            .background(.white)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                self.viewModel.setAudioRecording(audioRecording: self.viewModel.songs.first!)
            }
        }

        // MARK: Private

        @ObservedObject private var viewModel: MainViewViewModel
        @State private var selectedAudioRecording: AudioRecording
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
    @StateObject var viewModel = DanceFreeze.MainViewViewModel(songs: songs)

    return DanceFreeze.SongSelectorView(viewModel: viewModel)
}
