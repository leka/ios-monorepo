// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - NoAccountConnectedLabel

struct NoAccountConnectedLabel: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "person.crop.circle.badge.xmark")
                .resizable()
                .renderingMode(.original)
                .foregroundStyle(self.styleManager.accentColor!)
                .scaledToFit()
                .frame(width: 80)

            Text(l10n.NoAccountConnectedLabel.message)
                .foregroundColor(.orange)
                .font(.headline)
                .multilineTextAlignment(.center)

            Button(String(l10n.NoAccountConnectedLabel.buttonLabel.characters)) {
                self.navigation.setFullScreenCoverContent(.welcomeView)
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    var navigation = Navigation.shared
}

// MARK: - l10n.NoAccountConnectedLabel

// swiftlint:disable line_length

extension l10n {
    enum NoAccountConnectedLabel {
        static let message = LocalizedString("lekapp.not_account_connected_label.message", value: "You are currently using Leka without an account!.", comment: "Warning message when no account connected")

        static let buttonLabel = LocalizedString("lekapp.not_account_connected_label.button_label", value: "Log In or Sign Up", comment: "Button label to log in or sign up")
    }
}

// swiftlint:enable line_length

#Preview {
    NavigationSplitView(sidebar: {
        List {
            NoAccountConnectedLabel()

            Button {} label: {
                RobotConnectionLabel()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: -8, bottom: -8, trailing: -8))

            Section("Information") {
                Label("What's new?", systemImage: "lightbulb.max")
                Label("Resources", systemImage: "book.and.wrench")
            }
        }
    }, detail: {
        EmptyView()
    })
}
