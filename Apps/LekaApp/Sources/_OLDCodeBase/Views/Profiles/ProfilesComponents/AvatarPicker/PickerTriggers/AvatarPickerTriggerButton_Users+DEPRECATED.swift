// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AvatarPickerTriggerButton_UsersDeprecated: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated

    @Binding var navigate: Bool

    var body: some View {
        Button(
            action: {
                self.navigate.toggle()
            },
            label: {
                VStack(spacing: 10) {
                    AvatarTriggerImageViewDeprecated(img: self.company.getSelectedProfileAvatar(.user))
                    AvatarTriggerCTAViewDeprecated()
                }
            }
        )
        .buttonStyle(NoFeedback_ButtonStyle())
    }
}