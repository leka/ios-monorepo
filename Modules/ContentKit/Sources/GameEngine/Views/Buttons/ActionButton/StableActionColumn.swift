// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - StableActionColumn

struct StableActionColumn<Content: View>: View {
    // MARK: Lifecycle

    init(onTap: (() -> Void)? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.onTap = onTap
        self.content = content
    }

    // MARK: Internal

    var body: some View {
        HStack(spacing: 0) {
            self.actionFootprint

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)
        }
    }

    // MARK: Private

    private static var minimumFootprint: CGFloat { 260 }
    private static var contentPadding: CGFloat { 20 }

    private let onTap: (() -> Void)?
    private let content: () -> Content

    @ViewBuilder private var actionFootprint: some View {
        let footprint = self.content()
            .padding(Self.contentPadding)
            .frame(
                minWidth: Self.minimumFootprint,
                minHeight: Self.minimumFootprint,
                alignment: .center
            )

        if let onTap = self.onTap {
            footprint
                .contentShape(Rectangle())
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            onTap()
                        }
                )
        } else {
            footprint
        }
    }
}

// MARK: - ActionButtonColumn

struct ActionButtonColumn: View {
    // MARK: Lifecycle

    init(action: NewExerciseAction, onActionTriggered: @escaping () -> Void) {
        self.action = action
        self.onActionTriggered = onActionTriggered
    }

    // MARK: Internal

    var body: some View {
        StableActionColumn(onTap: self.onActionTriggered) {
            ActionButtonView(action: self.action)
        }
    }

    // MARK: Private

    private let action: NewExerciseAction
    private let onActionTriggered: () -> Void
}
