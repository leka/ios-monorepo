// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

public struct PlaceholderNoGameplayView: View {

    @StateObject private var viewModel: PlaceholderNoGameplayViewViewModel
    @State private var isDisabled: Bool = false

    public init() {
        self._viewModel = StateObject(wrappedValue: PlaceholderNoGameplayViewViewModel())
    }

    public init(exercise: Exercise, data: ExerciseSharedData? = nil) {
        self._viewModel = StateObject(
            wrappedValue: PlaceholderNoGameplayViewViewModel(shared: data))
    }

    public var body: some View {
        Button {
            viewModel.updateState()
            isDisabled = true
        } label: {
            Circle()
                .frame(width: 400, height: 400)
        }
        .disabled(isDisabled)
    }

}
