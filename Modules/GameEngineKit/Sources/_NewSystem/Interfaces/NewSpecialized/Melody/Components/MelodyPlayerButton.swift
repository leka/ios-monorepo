// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct MelodyPlayerButton: View {
    @Binding var showModal: Bool
    @State var isMelodyPlaying: Bool

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
                    .background {
                        Circle()
                            .fill(.white)
                    }
            }
            .disabled(self.isMelodyPlaying)
            .frame(width: 300)
        }
    }
}

#Preview {
    MelodyPlayerButton(showModal: .constant(true), isMelodyPlaying: false) {
        print("Play !")
    }
}
