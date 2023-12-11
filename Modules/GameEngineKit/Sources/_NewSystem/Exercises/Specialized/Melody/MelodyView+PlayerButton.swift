// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import DesignKit
import SwiftUI

extension MelodyView {
    struct PlayerButton: View {
        // MARK: Internal

        @Binding var showModal: Bool
        let action: () -> Void

        var body: some View {
            VStack {
                Button {
                    self.action()
                    withAnimation {
                        self.isMelodyPlaying.toggle()
                    }
                } label: {
                    Image(systemName: self.isMelodyPlaying ? "speaker.wave.2.circle" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(self.isMelodyPlaying ? .gray : .blue)
                        .background {
                            Circle()
                                .fill(.white)
                                .frame(width: 290)
                        }
                }
                .disabled(self.isMelodyPlaying)
                .frame(width: 300)
            }
        }

        // MARK: Private

        @State private var isMelodyPlaying: Bool = false
    }
}

#Preview {
    MelodyView.PlayerButton(showModal: .constant(true)) {
        print("Play !")
    }
}
