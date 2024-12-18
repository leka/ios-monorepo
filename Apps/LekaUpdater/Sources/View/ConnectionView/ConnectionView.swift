// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SwiftUI

struct ConnectionView: View {
    var body: some View {
        RobotConnectionView()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(l10n.main.appName)
                            .font(.title2)
                            .bold()
                        Text(l10n.main.appDescription)
                    }
                    .foregroundColor(.lkNavigationTitle)
                }
            }
    }
}

#Preview {
    NavigationStack {
        ConnectionView()
    }
}
