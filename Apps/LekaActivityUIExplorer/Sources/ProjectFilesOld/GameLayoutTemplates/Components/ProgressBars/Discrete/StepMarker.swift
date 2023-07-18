// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct StepMarker: View {

    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Binding var color: Color

    var body: some View {
        Circle()
            .fill(
                color,
                strokeBorder: .white,
                lineWidth: defaults.stepMarkerBorderWidth
            )
            .background(.white, in: Circle())
            .padding(defaults.stepMarkerPadding)
    }
}
