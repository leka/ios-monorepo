// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - SettingsLabel

struct SettingsLabel: View {
    // MARK: Internal

    var body: some View {
        Label(String(l10n.SettingsLabel.buttonLabel.characters), systemImage: "gear")
            .frame(width: 200, height: 44)
            .background(self.backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .contentShape(Rectangle())
    }

    // MARK: Private

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)
}

// MARK: - l10n.SettingsLabel

extension l10n {
    enum SettingsLabel {
        static let buttonLabel = LocalizedString("lekaapp.settings_label.title", value: "Settings", comment: "Settings button label")
    }
}

#Preview {
    SettingsLabel()
}
