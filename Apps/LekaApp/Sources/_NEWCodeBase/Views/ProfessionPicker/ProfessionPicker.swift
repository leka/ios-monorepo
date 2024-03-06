// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ProfessionPicker

struct ProfessionPicker: View {
    // MARK: Lifecycle

    init(selectedProfessionsIDs: [String], onCancel: (() -> Void)? = nil, onValidate: (([String]) -> Void)? = nil) {
        self.onCancel = onCancel
        self.onValidate = onValidate
        self.selectedProfessionsIDs = selectedProfessionsIDs
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    @State var selectedProfessions: Set<Profession> = []
    let selectedProfessionsIDs: [String]
    let onCancel: (() -> Void)?
    let onValidate: (([String]) -> Void)?

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
        .navigationTitle(String(l10n.ProfessionPicker.title.characters))
        .onAppear {
            let professions = self.selectedProfessionsIDs.compactMap { Professions.profession(for: $0) }
            self.selectedProfessions = Set(professions)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.action = .cancel
                    self.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.action = .validate
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
        .onDisappear {
            switch self.action {
                case .cancel:
                    self.onCancel?()
                case .validate:
                    // swiftformat:disable:next preferKeyPath
                    let professionIDs = self.selectedProfessions.compactMap { $0.id }
                    self.onValidate?(Array(professionIDs))
                case .none:
                    break
            }

            self.action = nil
        }
    }

    // MARK: Private

    private enum ActionType {
        case cancel
        case validate
    }

    @State private var action: ActionType?
    @State private var selectedProfessionForDetails: Profession?
}

// MARK: - ProfessionPicker_Previews

#Preview {
    NavigationStack {
        ProfessionPicker(selectedProfessionsIDs: Caregiver().professions,
                         onValidate: {
                             print("Selected professions: \($0)")
                         })
    }
}
