// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SongModel: Hashable, Equatable {
    let id: UUID = UUID()
    let name: String
    let file: String
}

private let kAvailableSongs: [SongModel] = [
    SongModel(name: "Frère Jacques", file: "song_1.mp3"),
    SongModel(name: "Dansons la Capucine", file: "song_2.mp3"),
    SongModel(name: "Petit Escargot", file: "song_3.mp3"),
    SongModel(name: "Stairway to Heaven", file: "song_4.mp3"),
    SongModel(name: "Can you feel the love tonight", file: "song_5.mp3"),
    SongModel(name: "Cette année là", file: "song_6.mp3"),
]

struct SongSelector: View {
    @State private var selectedSong: SongModel = kAvailableSongs.first!

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
                    ForEach(kAvailableSongs, id: \.self) { song in
                        Button {
                            selectedSong = song
                        } label: {
                            HStack {
                                Image(systemName: song == selectedSong ? "checkmark.circle.fill" : "circle")
                                    .imageScale(.large)
                                    .foregroundColor(
                                        song == selectedSong
                                            ? .green : LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor
                                    )
                                Text(song.name)
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
        .foregroundColor(LekaActivityUIExplorerAsset.Colors.lekaDarkGray.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct SongSelector_Previews: PreviewProvider {
    static var previews: some View {
        SongSelector()
    }
}
