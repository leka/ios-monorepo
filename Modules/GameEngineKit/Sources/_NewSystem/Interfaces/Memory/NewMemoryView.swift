// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - NewMemoryView

public struct NewMemoryView: View {
    // MARK: Lifecycle

    public init(viewModel: NewMemoryViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[0...2]) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onTapped(choice: choice)
                        }
                }
            }

            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[3...5]) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onTapped(choice: choice)
                        }
                }
            }
        }
    }

    // MARK: Private

    @StateObject private var viewModel: NewMemoryViewViewModel
}
