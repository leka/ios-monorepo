// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ProfessionPicker

struct ProfessionPicker: View {
    // MARK: Internal

    @Binding var caregiver: Caregiver
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List(Professions.list, id: \.self, selection: self.$selectedProfessions) { profession in
            Text(profession.name)
        }
        .environment(\.editMode, Binding.constant(EditMode.active))
        .onAppear {
            self.selectedProfessions = Set(self.caregiver.professions)
        }
        .navigationTitle(String(l10n.ProfessionPicker.title.characters))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.caregiver.professions = Array(self.selectedProfessions)
                    self.dismiss()
                } label: {
                    Label(String(l10n.ProfessionPicker.validateButton.characters), systemImage: "checkmark.circle")
                }
                .disabled(self.selectedProfessions.isEmpty)
            }
        }
    }

    // MARK: Private

    @State private var otherProfessionText: String = ""
    @State private var selectedProfessions: Set<Profession> = []
}

// MARK: - ProfessionPicker_Previews

#Preview {
    NavigationStack {
        ProfessionPicker(caregiver: .constant(Caregiver()))
    }
}
