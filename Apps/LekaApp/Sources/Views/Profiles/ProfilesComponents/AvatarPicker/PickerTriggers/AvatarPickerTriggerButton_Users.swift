// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AvatarPickerTriggerButton_Users: View {
    @EnvironmentObject var company: CompanyViewModel

    @Binding var navigate: Bool

    var body: some View {
        Button(
            action: {
                self.navigate.toggle()
            },
            label: {
                VStack(spacing: 10) {
                    AvatarTriggerImageView(img: self.company.getSelectedProfileAvatar(.user))
                    AvatarTriggerCTAView()
                }
            }
        )
        .buttonStyle(NoFeedback_ButtonStyle())
    }
}
