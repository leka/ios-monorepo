// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import Fit
import LocalizationKit
import SwiftUI

struct ProfessionListView: View {
    // MARK: Lifecycle

    init(caregiver: Binding<Caregiver>) {
        self._caregiver = caregiver
    }

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            LabeledContent(String(l10n.CaregiverCreation.professionLabel.characters)) {
                Button {
                    self.isProfessionPickerPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: self.$isProfessionPickerPresented) {
                    NavigationStack {
                        ProfessionPicker(selectedProfessionsIDs: self.caregiver.professions,
                                         onSelect: { professions in
                                             self.caregiver.professions = professions
                                         })
                                         .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }

            if !self.caregiver.professions.isEmpty {
                Fit {
                    ForEach(self.caregiver.professions, id: \.self) { id in
                        let profession = Professions.profession(for: id)!

                        TagView(title: profession.name, systemImage: "multiply.square.fill") {
                            self.caregiver.professions.removeAll(where: { id == $0 })
                        }
                    }
                }
            }
        }
    }

    // MARK: Private

    @State private var isProfessionPickerPresented: Bool = false

    @Binding private var caregiver: Caregiver
}

#Preview {
    @Previewable
    @State var caregiver = Caregiver(professions: [
        Professions.list[0].id,
        Professions.list[1].id,
        Professions.list[3].id,

    ])

    return Text("Preview")
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                List {
                    ProfessionListView(caregiver: $caregiver)
                }
            }
        }
}
