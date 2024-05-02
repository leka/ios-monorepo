// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - LoadingModifier

struct LoadingModifier: ViewModifier {
    var isLoading: Bool
    var forceWhiteTint: Bool

    func body(content: Content) -> some View {
        content
            .opacity(self.isLoading ? 0 : 1)
            .overlay(
                Group {
                    if self.isLoading {
                        if self.forceWhiteTint {
                            ProgressView().tint(.white)
                        } else {
                            ProgressView()
                        }
                    }
                }
            )
            .animation(.easeInOut, value: self.isLoading)
    }
}

extension View {
    func loadingIndicator(isLoading: Bool, forceWhiteTint: Bool = false) -> some View {
        modifier(LoadingModifier(isLoading: isLoading, forceWhiteTint: forceWhiteTint))
    }
}

#Preview {
    VStack {
        Button {}
            label: {
                Text("Connect")
                    .loadingIndicator(isLoading: false)
            }
            .buttonStyle(.borderedProminent)

        Button {}
            label: {
                Text("Connect")
                    .loadingIndicator(isLoading: true)
            }
            .buttonStyle(.borderedProminent)
    }
}
