// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - ChangelogView

struct ChangelogView: View {
    // MARK: Internal

    var body: some View {
        Text(self.changelog)
    }

    // MARK: Private

    private var changelog: LocalizedStringKey {
        // swiftlint:disable:next force_cast
        let osVersion = Bundle.main.object(forInfoDictionaryKey: "LEKA_OS_VERSION") as! String
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
