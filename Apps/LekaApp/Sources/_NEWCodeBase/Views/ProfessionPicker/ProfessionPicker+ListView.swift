// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

extension ProfessionPicker {
    struct ListView: View {
        // MARK: Internal

        @Binding var selectedProfessions: [Profession]

        var body: some View {
            ScrollView {
                let columns = Array(repeating: GridItem(), count: 3)
                LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
                    ForEach(Professions.list, id: \.id) { profession in
                        Label(profession.name,
                              systemImage: self.selectedProfessions.contains(profession) ? "checkmark.circle.fill" : "circle")
                            // TODO: (@ui/ux) - Design System - replace with Leka font
                            .font(.subheadline)
                            .foregroundStyle(self.selectedProfessions.contains(profession) ? .green : self.styleManager.accentColor!)
                            .animation(.easeIn, value: self.selectedProfessions)
                            .onTapGesture {
                                if self.selectedProfessions.contains(profession) {
                                    self.selectedProfessions.removeAll(where: { profession == $0 })
                                } else {
                                    self.selectedProfessions.append(profession)
                                }
                            }
                    }
                }
                .padding()
            }
            .padding()
        }

        // MARK: Private

        @ObservedObject private var styleManager: StyleManager = .shared
    }
}

#Preview {
    ProfessionPicker.ListView(selectedProfessions: .constant([]))
}
