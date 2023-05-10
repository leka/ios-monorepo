// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct ChangelogView: View {
    private var changeLog: String {
        do {
            guard let fileURL = Bundle.main.url(forResource: "LekaOS-1.4.0", withExtension: "md") else {
                return "Changelog not found"
            }

            let contents = try String(contentsOf: fileURL)
            return contents
        } catch {
            return "ERROR"
        }
    }

    var body: some View {
        ScrollView {
            Text(changeLog)
                .padding()
        }
        .border(.black)
        .frame(maxHeight: 300)
    }
}

struct ChangelogView_Previews: PreviewProvider {
    static var previews: some View {
        ChangelogView()
    }
}
