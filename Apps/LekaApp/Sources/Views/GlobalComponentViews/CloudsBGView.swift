// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct CloudsBGView: View {
    var body: some View {
        Image("interface_cloud")
            .resizable()
            .renderingMode(.original)
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CloudsBGView_Previews: PreviewProvider {
    static var previews: some View {
        CloudsBGView()
    }
}
