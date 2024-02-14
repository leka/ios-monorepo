// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CarereceiversView

struct CarereceiverView: View {
    // MARK: Internal

    @State var carereceiver: Carereceiver

    var body: some View {
        Button {
            self.rootOwnerViewModel.isCarereceiverSettingsViewPresented = true
        } label: {
            CarereceiverAvatarCell(carereceiver: self.carereceiver)
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isCarereceiverSettingsViewPresented) {
            CarereceiverSettingsView(modifiedCarereceiver: self.$carereceiver)
        }
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared
}

#Preview {
    CarereceiverView(carereceiver: Carereceiver())
}
