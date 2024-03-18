// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - LoadingModifier

struct LoadingModifier: ViewModifier {
    var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .opacity(self.isLoading ? 0 : 1)
            .overlay(
                Group {
                    if self.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
            )
            .animation(.easeInOut, value: self.isLoading)
    }
}

extension View {
    func loadingText(isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
