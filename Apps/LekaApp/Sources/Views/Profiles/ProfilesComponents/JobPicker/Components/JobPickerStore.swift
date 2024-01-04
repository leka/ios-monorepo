// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct JobPickerStore: View {
    // MARK: Internal

    @Binding var selectedJobs: [String]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                let columns = Array(repeating: GridItem(), count: 3)
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(Professions.allCases) { profession in
                        Toggle(isOn: .constant(self.selectedJobs.contains(profession.name))) {
                            Text(profession.name)
                        }
                        .toggleStyle(
                            JobPickerToggleStyle(action: {
                                self.jobSelection(profession: profession.name)
                            }))
                    }
                }
                .padding(.vertical, 30)
            }
        }
    }

    // MARK: Private

    private func jobSelection(profession: String) {
        if self.selectedJobs.contains(profession) {
            self.selectedJobs.removeAll(where: { profession == $0 })
        } else {
            self.selectedJobs.append(profession)
        }
    }
}
