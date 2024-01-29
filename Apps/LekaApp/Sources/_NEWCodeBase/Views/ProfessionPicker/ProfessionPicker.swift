// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ProfessionPicker

struct ProfessionPicker: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ListView(selectedProfessions: self.$selectedProfessions)
            .onAppear {
                self.selectedProfessions = self.rootOwnerViewModel.bufferCaregiver.professions
            }
            .safeAreaInset(edge: .bottom) {
                TextFieldDefault(label: String(l10n.ProfessionPicker.otherLabel.characters), entry: self.$otherProfessionText)
                    .frame(width: 400)
                    .padding()
                    .onSubmit {
                        self.selectedProfessions.append(.other(profession: self.otherProfessionText))
                    }
            }
            .navigationTitle(String(l10n.ProfessionPicker.title.characters))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.rootOwnerViewModel.bufferCaregiver.professions = self.selectedProfessions
                        self.dismiss()
                    } label: {
                        Label(String(l10n.ProfessionPicker.validateButton.characters), systemImage: "checkmark.circle")
                    }
                    .disabled(self.selectedProfessions.isEmpty)
                }
            }
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @State private var otherProfessionText: String = ""
    @State private var selectedProfessions: [Caregiver.Profession] = []
}

// MARK: - ProfessionPicker_Previews

#Preview {
    ProfessionPicker()
}
