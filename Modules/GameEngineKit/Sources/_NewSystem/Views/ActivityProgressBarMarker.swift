// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ActivityProgressBarMarker: View {

    @State var color: Color = .white
    @State var isCurrent: Bool

    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 3)
            .background(color, in: Circle())
            .overlay {
                currentExerciseIndicator
            }
    }

    @ViewBuilder private var currentExerciseIndicator: some View {
        if isCurrent {
            Circle()
                .fill(DesignKitAsset.Colors.darkGray.swiftUIColor)
                .padding(6)
        }
    }
}
