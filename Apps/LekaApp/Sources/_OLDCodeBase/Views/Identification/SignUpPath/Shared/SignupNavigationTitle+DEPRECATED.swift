// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SignupNavigationTitleDeprecated: View {
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Text("Première connexion")
            .font(.headline)
    }
}
