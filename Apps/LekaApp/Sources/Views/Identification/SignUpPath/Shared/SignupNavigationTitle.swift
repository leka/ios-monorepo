// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupNavigationTitle: View {

    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Text("Première connexion")
            .font(metrics.semi17)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }
}
