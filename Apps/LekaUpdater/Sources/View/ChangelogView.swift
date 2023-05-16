// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ChangelogView: View {
    private var changelog: String {
        // swiftlint:disable:next force_cast
        let osVersion = Bundle.main.object(forInfoDictionaryKey: "LEKA_OS_VERSION") as! String
        let fileURL = Bundle.main.url(forResource: "LekaOS-\(osVersion)", withExtension: "md")!

        do {
            return try String(contentsOf: fileURL)
        } catch {
            return "Changelog cannot be loaded"
        }
    }

    var body: some View {
        ScrollView {
            Text(changelog)
                .padding()
        }
        .border(.black)
        .frame(idealHeight: 300, maxHeight: 300)
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
    }
}
