// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

public struct StepView: View {
    @StateObject private var viewModel: StepViewViewModel

    public init(stepManager: StepManager) {
        self._viewModel = StateObject(wrappedValue: StepViewViewModel(stepManager: stepManager))
    }

    public var body: some View {
        viewModel.currentView
    }
}
