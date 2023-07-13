// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct ChangelogView: View {
    private var changelog: LocalizedStringKey {
        // swiftlint:disable:next force_cast
        let osVersion = Bundle.main.object(forInfoDictionaryKey: "LEKA_OS_VERSION") as! String
        let fileURL = Bundle.main.url(forResource: "LekaOS-\(osVersion)", withExtension: "md")!

        do {
            let content = try String(contentsOf: fileURL)
            return LocalizedStringKey(stringLiteral: content)
        } catch {
            return "Changelog cannot be loaded"
        }
    }

    var body: some View {
        Text(changelog)
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
    }
}
