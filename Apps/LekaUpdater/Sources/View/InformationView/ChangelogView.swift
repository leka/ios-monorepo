// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - ChangelogView

struct ChangelogView: View {
    // MARK: Internal

    var body: some View {
        Text(self.changelog)
    }

    // MARK: Private

    private var changelog: LocalizedStringKey {
        let osVersion = Robot.kLatestFirmwareVersion
        var languageCode: String {
            guard let language = Locale.current.language.languageCode?.identifier else { return "en" }
            return language == "fr" ? "fr" : "en"
        }

        let fileURL = Bundle.main.url(
            forResource: "LekaOS-\(osVersion)-\(languageCode)",
            withExtension: "md"
        )!

        do {
            let content = try String(contentsOf: fileURL)
            return LocalizedStringKey(stringLiteral: content)
        } catch {
            return "\(l10n.information.changelogNotFoundText)"
        }
    }
}

// MARK: - ChangelogView_Previews

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
