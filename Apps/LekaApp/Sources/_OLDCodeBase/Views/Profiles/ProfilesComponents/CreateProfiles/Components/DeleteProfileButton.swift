// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DeleteProfileButton: View {
    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics

    @Binding var show: Bool

    var body: some View {
        if self.company.editingProfile {
            Button {
                self.show.toggle()
            } label: {
                Label("Supprimer le profil", systemImage: "trash.fill")
                    .padding(.horizontal, 20)
            }
            .buttonStyle(BorderedCapsule_NoFeedback_ButtonStyle(font: .body, color: Color.red))
            .padding(.vertical, 10)
        } else {
            EmptyView()
        }
    }
}
