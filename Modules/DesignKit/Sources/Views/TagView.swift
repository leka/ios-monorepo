// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct TagView: View {
    // MARK: Lifecycle

    public init(title: String, systemImage: String = "", action: (() -> Void)? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    // MARK: Public

    public var body: some View {
        Button {
            self.action?()
        } label: {
            HStack(spacing: 12) {
                Text(self.title)

                if !self.systemImage.isEmpty {
                    Image(systemName: self.systemImage)
                        .foregroundStyle(self.styleManager.accentColor!)
                        .font(.callout)
                }
            }
        }
        .buttonStyle(.bordered)
        .foregroundStyle(.secondary)
        .tint(nil)
    }

    // MARK: Private

    private var styleManager: StyleManager = .shared

    private let title: String
    private let systemImage: String
    private let action: (() -> Void)?
}

#Preview {
    VStack {
        TagView(title: "Add", systemImage: "plus")
        TagView(title: "Add", systemImage: "")
        TagView(title: "Add")
    }
}
