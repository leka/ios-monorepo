// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - ActivityViewViewModel

class ActivityViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(activity: Activity) {
        self.activity = activity
    }

    // MARK: Internal

    let activity: Activity
}

// MARK: - ActivityView

public struct ActivityView: View {
    // MARK: Lifecycle

    public init(activity: Activity) {
        self._viewModel = StateObject(wrappedValue: ActivityViewViewModel(activity: activity))
    }

    // MARK: Public

    public var body: some View {
        Text("Hello, \(self.viewModel.activity.name)!")
    }

    // MARK: Internal

    @StateObject var viewModel: ActivityViewViewModel
}

#Preview {
    ActivityView(activity: Activity.mock)
}
