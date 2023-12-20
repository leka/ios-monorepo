// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - DragAndDropToSequenceActivityView

struct DragAndDropToSequenceActivityView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            DragAndDropToSequenceView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Dismiss") {
                            self.dismiss()
                        }
                    }
                }
        }
    }
}
