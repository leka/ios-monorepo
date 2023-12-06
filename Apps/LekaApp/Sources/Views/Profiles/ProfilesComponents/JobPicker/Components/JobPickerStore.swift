// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct JobPickerStore: View {
    @Binding var selectedJobs: [String]
    private func jobSelection(profession: String) {
        if selectedJobs.contains(profession) {
            selectedJobs.removeAll(where: { profession == $0 })
        } else {
            selectedJobs.append(profession)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                let columns = Array(repeating: GridItem(), count: 3)
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(Professions.allCases) { profession in
                        Toggle(isOn: .constant(selectedJobs.contains(profession.name))) {
                            Text(profession.name)
                        }
                        .toggleStyle(
                            JobPickerToggleStyle(action: {
                                jobSelection(profession: profession.name)
                            }))
                    }
                }
                .padding(.vertical, 30)
            }
        }
    }
}
