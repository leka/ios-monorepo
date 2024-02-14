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
            self.rootOwnerViewModel.isEditCarereceiverViewPresented = true
        } label: {
            CarereceiverAvatarCell(carereceiver: self.carereceiver)
        }
        .sheet(isPresented: self.$rootOwnerViewModel.isEditCarereceiverViewPresented) {
            EditCarereceiverView(modifiedCarereceiver: self.$carereceiver)
        }
    }

    // MARK: Private

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
}

#Preview {
    CarereceiverView(carereceiver: Carereceiver())
}
