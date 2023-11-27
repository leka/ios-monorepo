// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import RobotKit
import SwiftUI

struct ConnectionView: View {
    var body: some View {
        NavigationStack {
            RobotConnectionView()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text(l10n.main.appName)
                                .font(.title2)
                                .bold()
                            Text(l10n.main.appDescription)
                        }
                        .foregroundColor(.accentColor)
                    }
                }
        }
    }
}

#Preview {
    return ConnectionView()
        .environment(\.locale, .init(identifier: "en"))
    return ConnectionView()
        .environment(\.locale, .init(identifier: "fr"))
}
