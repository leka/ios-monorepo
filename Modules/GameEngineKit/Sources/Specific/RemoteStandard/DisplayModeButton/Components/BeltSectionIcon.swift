// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BeltSectionIcon: View {
    var section: BeltSection

    @State private var backgroundLineWidth = 0

    var body: some View {
        ArcShape(section: section)
            .stroke(.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: 60, height: 60)
    }
}

struct BeltSectionIcon_Previews: PreviewProvider {
    static var previews: some View {
        BeltSectionIcon(section: .backLeft)
    }
}
