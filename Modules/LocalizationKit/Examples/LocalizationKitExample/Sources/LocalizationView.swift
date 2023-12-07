// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension l10n {
    static let localizedStringNoDefault = LocalizedString("localized_string_NO_default", value: "", comment: "")

    static let localizedStringWithDefault = LocalizedString(
        "localized_string_WITH_default", value: "⛳ DEFAULT localized_string_WITH_default", comment: ""
    )

    static let localizedStringInterpolation = LocalizedStringInterpolation(
        "localized_string_interpolation",
        value: "⛳ DEFAULT localized_string_interpolation - text: %@ - int: %lld - float: %f", comment: ""
    )

    static let localizedStringWithMarkdown = LocalizedString(
        "localized_string_with_markdown", value: "⛳ **DEFAULT** *localized_string_with_markdown*", comment: ""
    )

    static let localizedStringInterpolationWithMarkdown = LocalizedStringInterpolation(
        "localized_string_interpolation_with_markdown",
        value:
        "⛳ **DEFAULT** *localized_string_interpolation_with_markdown* - **text: %@** - *int: %lld* - ***float: %f***",
        comment: ""
    )
}

// MARK: - LocalizationView

struct LocalizationView: View {
    @Environment(\.locale) var locale

    let nameValue = "John *Doe* [link]"
    let intValue = 42
    let floatValue = 3.14

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: "Current locale: \(locale)")
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_NO_default")
                    .bold()
                Text(l10n.localizedStringNoDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_WITH_default")
                    .bold()
                Text(l10n.localizedStringWithDefault)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_interpolation")
                    .bold()
                Text(l10n.localizedStringInterpolation(nameValue, intValue, floatValue))
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_with_markdown")
                    .bold()
                Text(l10n.localizedStringWithMarkdown)
            }

            VStack(alignment: .leading) {
                Text(verbatim: "localized_string_interpolation_with_markdown")
                    .bold()
                Text(l10n.localizedStringInterpolationWithMarkdown(nameValue, intValue, floatValue))
            }
        }
    }
}

#Preview {
    VStack(spacing: 80) {
        LocalizationView()
            .environment(\.locale, .init(identifier: "en"))

        LocalizationView()
            .environment(\.locale, .init(identifier: "fr"))
    }
}
