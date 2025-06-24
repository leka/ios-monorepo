// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - EmptySharedLibraryPlaceholderView

struct EmptySharedLibraryPlaceholderView: View {
    // MARK: Lifecycle

    init(icon: Icon) {
        self.icon = icon
    }

    // MARK: Internal

    enum Icon {
        case activities
        case curriculums
        case stories

        // MARK: Internal

        var systemName: String {
            switch self {
                case .activities:
                    "dice"
                case .curriculums:
                    "graduationcap"
                case .stories:
                    "text.book.closed"
            }
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: self.icon.systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(self.styleManager.accentColor ?? .blue)
                .padding(.bottom, 16)

            Text(l10n.EmptySharedLibraryPlaceholderView.sharedLibraryIsEmpty)
                .font(.headline)

            HStack(spacing: 4) {
                Text(l10n.EmptySharedLibraryPlaceholderView.tapThe)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(self.styleManager.accentColor ?? .blue)
                    .accessibility(label: Text("More Options"))
                Text(l10n.EmptySharedLibraryPlaceholderView.addItems)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)

            Text(l10n.EmptySharedLibraryPlaceholderView.removeItems)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: Private

    private var styleManager: StyleManager = .shared
    private let icon: Icon
}

// MARK: - l10n.EmptySharedLibraryPlaceholderView

extension l10n {
    enum EmptySharedLibraryPlaceholderView {
        static let sharedLibraryIsEmpty = LocalizedString(
            "lekaapp.empty_shared_library_placedholder_view.shared_library_is_empty",
            value: "Your shared Library is Empty",
            comment: "Empty shared library title"
        )
        static let tapThe = LocalizedString(
            "lekaapp.empty_shared_library_placedholder_view.tap_the",
            value: "Tap the",
            comment: "Instruction prefix"
        )
        static let addItems = LocalizedString(
            "lekaapp.empty_shared_library_placedholder_view.add_items",
            value: "button on any content to add them to your Shared Library.",
            comment: "Add instruction suffix"
        )
        static let removeItems = LocalizedString(
            "lekaapp.empty_shared_library_placedholder_view.remove_items",
            value: "You can remove items from your Shared Library using the same button.",
            comment: "Removal instruction"
        )
    }
}

#Preview {
    EmptySharedLibraryPlaceholderView(icon: .stories)
}
