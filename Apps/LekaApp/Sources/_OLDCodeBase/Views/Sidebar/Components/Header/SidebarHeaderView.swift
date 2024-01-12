// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct SidebarHeaderView: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        VStack(spacing: 10) {
            self.logoLeka
            GoToProfileEditorButton()
            GoToRobotConnectButton()
        }
        .frame(minHeight: 350, idealHeight: 350, maxHeight: 371)
    }

    // MARK: Private

    private var logoLeka: some View {
        DesignKitAsset.Assets.lekaLogo.swiftUIImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.top, 20)
    }
}
