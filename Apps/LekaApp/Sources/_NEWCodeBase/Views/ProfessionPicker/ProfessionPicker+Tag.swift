// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

extension ProfessionPicker {
    struct ProfessionTag: View {
        @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
        @State var profession: Profession
        @Binding var caregiver: Caregiver

        var body: some View {
            Button {
                // nothing to do
            } label: {
                HStack(spacing: 12) {
                    Text(self.profession.name)

                    Image(systemName: "multiply.square.fill")
                        .onTapGesture {
                            self.caregiver.professions.removeAll(where: { self.profession == $0 })
                        }
                }
            }
            .font(.caption)
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ProfessionPicker.ProfessionTag(
        profession: Professions.list[8],
        caregiver: .constant(Caregiver(professions: [Professions.list[0], Professions.list[3]]))
    )
}
