// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

public extension StoryView.PageView {
    struct TextView: View {
        // MARK: Lifecycle

        public init(payload: PagePayloadProtocol) {
            guard let payload = payload as? TextPayload else {
                fatalError("💥 Story item is not TextPayload")
            }
            self.text = payload.text
        }

        // MARK: Public

        public var body: some View {
            Text(self.text)
                .font(Font(UIFont(name: "ChalkboardSE-Light", size: CGFloat(26)) ?? .systemFont(ofSize: 26)))
        }

        // MARK: Private

        private let text: String
    }
}

#Preview {
    NavigationStack {
        StoryView.PageView.TextView(payload: Story.mock.pages[1].items[0].payload)
    }
}
