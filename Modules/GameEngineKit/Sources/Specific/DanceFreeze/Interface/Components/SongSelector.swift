// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SongModel: Hashable, Equatable {
    let id: UUID = UUID()
    let name: String
    let file: String
}

private let kAvailableSongs: [SongModel] = [
    // TO DO : (@hugo) Replace nyan by validated free use music
    SongModel(name: "Frère Jacques", file: "nyan"),
    SongModel(name: "Dansons la Capucine", file: "nyan"),
    SongModel(name: "Petit Escargot", file: "nyan"),
    SongModel(name: "Stairway to Heaven", file: "nyan"),
    SongModel(name: "Can you feel the love tonight", file: "nyan"),
    SongModel(name: "Cette année là", file: "nyan"),
]

struct SongSelector: View {
    @EnvironmentObject private var viewModel: DanceFreezeViewModel
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
                            viewModel.setSong(song: selectedSong)
                        } label: {
                            HStack {
                                Image(systemName: song == selectedSong ? "checkmark.circle.fill" : "circle")
                                    .imageScale(.large)
                                    .foregroundColor(
                                        song == selectedSong
                                            ? .green : DesignKitAsset.Colors.lekaDarkGray.swiftUIColor
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
        .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .onAppear {
            viewModel.setSong(song: kAvailableSongs[0])
        }
    }
}
