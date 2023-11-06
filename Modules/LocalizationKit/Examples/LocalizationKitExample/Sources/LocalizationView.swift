// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

extension l10n {

    static let localizedStringNoDefault = LocalizedString("localized_string_NO_default", value: "", comment: "")

    static let localizedStringWithDefault = LocalizedString(
        "localized_string_WITH_default", value: "⛳ DEFAULT localized_string_WITH_default", comment: "")

    static let localizedStringInterpolation = LocalizedStringInterpolation(
        "localized_string_interpolation",
        value: "⛳ DEFAULT localized_string_interpolation - text: %@ - int: %lld - float: %f", comment: "")

}

struct LocalizationView: View {

    @Environment(\.locale) var locale

    let nameValue = "John Doe"
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
