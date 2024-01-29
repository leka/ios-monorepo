// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

extension ProfessionPicker {
    struct ProfessionTag: View {
        @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
        @State var profession: Caregiver.Profession

        var body: some View {
            Button {
                // nothing to do
            } label: {
                HStack(spacing: 12) {
                    Text(self.profession.name)

                    Image(systemName: "multiply.square.fill")
                        .onTapGesture {
                            self.rootOwnerViewModel.bufferCaregiver.professions.removeAll(where: { self.profession == $0 })
                        }
                }
            }
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.caption)
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    ProfessionPicker.ProfessionTag(profession: Caregiver.Profession.occupationalTherapist)
}
