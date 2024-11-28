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

    init(selectedProfessionsIDs: [String], onCancel: (() -> Void)? = nil, onSelect: (([String]) -> Void)? = nil) {
        self.onCancel = onCancel
        self.onSelect = onSelect
        self.selectedProfessionsIDs = selectedProfessionsIDs
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    @State var selectedProfessions: Set<Profession> = []

    let selectedProfessionsIDs: [String]
    let onCancel: (() -> Void)?
    let onSelect: (([String]) -> Void)?

    var body: some View {
        List(Professions.list, id: \.self, selection: self.$selectedProfessions) { profession in
            HStack {
                Text(profession.name)
                    .foregroundStyle(Color.primary)
                Spacer()
                Image(systemName: "info.circle")
                    .onTapGesture {
                        self.selectedProfessionForDetails = profession
                    }
                    .foregroundStyle(self.selectedProfessions.contains(profession) ? Color.white : self.styleManager.accentColor!)
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
                    Text(l10n.ProfessionPicker.closeButtonLabel)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.action = .select
                    self.dismiss()
                } label: {
                    Text(l10n.ProfessionPicker.selectButtonLabel)
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
            .padding()
        })
        .onDisappear {
            switch self.action {
                case .cancel:
                    self.onCancel?()
                case .select:
                    // swiftformat:disable:next preferKeyPath
                    let professionIDs = self.selectedProfessions.compactMap { $0.id }
                    self.onSelect?(Array(professionIDs))
                case .none:
                    break
            }

            self.action = nil
        }
    }

    // MARK: Private

    private enum ActionType {
        case cancel
        case select
    }

    @State private var action: ActionType?
    @State private var selectedProfessionForDetails: Profession?
    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - ProfessionPicker_Previews

#Preview {
    NavigationStack {
        ProfessionPicker(selectedProfessionsIDs: Caregiver().professions,
                         onSelect: {
                             print("Selected professions: \($0)")
                         })
    }
}
