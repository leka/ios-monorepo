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

    @Environment(\.dismiss) var dismiss

    @Binding var caregiver: Caregiver

    var body: some View {
        List(Professions.list, id: \.self, selection: self.$selectedProfessions) { profession in
            HStack {
                Text(profession.name)
                Spacer()
                Image(systemName: "info.circle")
                    .onTapGesture {
                        self.selectedProfessionForDetails = profession
                    }
                    .foregroundStyle(self.selectedProfessions.contains(profession) ? Color.white : Color.accentColor)
            }
        }
        .environment(\.editMode, Binding.constant(EditMode.active))
        .onAppear {
            let professions = self.caregiver.professions.compactMap { Professions.profession(for: $0) }
            self.selectedProfessions = Set(professions)
        }
        .navigationTitle(String(l10n.ProfessionPicker.title.characters))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let professionIDs = self.selectedProfessions.compactMap(\.id)
                    self.caregiver.professions = Array(professionIDs)
                    self.dismiss()
                } label: {
                    Label(String(l10n.ProfessionPicker.validateButton.characters), systemImage: "checkmark.circle")
                }
                .disabled(self.selectedProfessions.isEmpty)
            }
        }
        .sheet(item: self.$selectedProfessionForDetails, onDismiss: { self.selectedProfessionForDetails = nil }, content: { profession in
            VStack(spacing: 40) {
                Text(profession.name)
                    .font(.largeTitle)
                Text(profession.description)
                    .padding(.horizontal, 20)
                    .font(.title2)
            }
        })
    }

    // MARK: Private

    @State private var otherProfessionText: String = ""
    @State private var selectedProfessions: Set<Profession> = []
    @State private var selectedProfessionForDetails: Profession?
}

// MARK: - ProfessionPicker_Previews

#Preview {
    NavigationStack {
        ProfessionPicker(caregiver: .constant(Caregiver()))
    }
}
