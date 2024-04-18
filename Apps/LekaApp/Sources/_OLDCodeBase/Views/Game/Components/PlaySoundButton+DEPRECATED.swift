// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - PlaySoundButtonDeprecated

struct PlaySoundButtonDeprecated: View {
    @EnvironmentObject var activityVM: ActivityViewModelDeprecated

    var body: some View {
        Button(
            action: {
                self.activityVM.audioPlayer.play()
            },
            label: {
                Image(systemName: "speaker.2")
                    .font(.system(size: 100, weight: .medium))
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .padding(40)
            }
        )
        .buttonStyle(PlaySound_ButtonStyleDeprecated(progress: self.activityVM.progress))
        .frame(
            width: 160,
            height: 200,
            alignment: .center
        )
        .scaleEffect(self.activityVM.audioPlayer.isPlaying ? 1.0 : 0.8, anchor: .center)
        .shadow(
            color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor.opacity(0.2),
            radius: self.activityVM.audioPlayer.isPlaying ? 6 : 3, x: 0, y: 3
        )
        .animation(.spring(response: 0.3, dampingFraction: 0.45), value: self.activityVM.audioPlayer.isPlaying)
        .disabled(self.activityVM.audioPlayer.isPlaying)
    }
}

// MARK: - PlaySoundButton_Previews

struct PlaySoundButton_Previews: PreviewProvider {
    static var previews: some View {
        PlaySoundButtonDeprecated()
            .environmentObject(ActivityViewModelDeprecated())
    }
}
