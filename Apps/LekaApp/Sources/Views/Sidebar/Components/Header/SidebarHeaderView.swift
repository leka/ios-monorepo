// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct SidebarHeaderView: View {

    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        VStack(spacing: 10) {
            logoLeka
            GoToProfileEditorButton()
            GoToRobotConnectButton()
        }
        .frame(minHeight: 350, idealHeight: 350, maxHeight: 371)
    }

    private var logoLeka: some View {
        Image("lekaLogo_AFH")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
            .padding(.top, 20)
    }
}
