// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct PlaySoundButton: View {
    @EnvironmentObject var activityVM: ActivityViewModel

    var body: some View {
        Button(
            action: {
                activityVM.audioPlayer.play()
            },
            label: {
                Image(systemName: "speaker.2")
                    .font(.system(size: 100, weight: .medium))
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .padding(40)
            }
        )
        .buttonStyle(PlaySound_ButtonStyle(progress: activityVM.progress))
        .frame(
            width: 160,
            height: 200,
            alignment: .center
        )
        .scaleEffect(activityVM.audioPlayer.isPlaying ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor.opacity(0.2),
            radius: activityVM.audioPlayer.isPlaying ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: activityVM.audioPlayer.isPlaying)
        .disabled(activityVM.audioPlayer.isPlaying)
    }
}

struct PlaySoundButton_Previews: PreviewProvider {
    static var previews: some View {
        PlaySoundButton()
            .environmentObject(ActivityViewModel())
    }
}
