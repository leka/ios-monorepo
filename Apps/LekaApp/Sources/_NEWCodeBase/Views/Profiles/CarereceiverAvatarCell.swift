// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct CarereceiverAvatarCell: View {
    // MARK: Internal

    private let backgroundColor: Color = .init(light: UIColor.white, dark: UIColor.systemGray5)
    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    let carereceiver: Carereceiver

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Image(self.carereceiver.avatar, bundle: Bundle(for: DesignKitResources.self))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())

                ZStack {
                    Circle()
                        .fill(DesignKitAsset.Colors.lekaLightGray.swiftUIColor)

                    Image(uiImage: self.rootOwnerViewModel.getReinforcerFor(index: self.carereceiver.reinforcer))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(5)

                    Circle()
                        .stroke(self.backgroundColor, lineWidth: 3)
                }
                .frame(maxWidth: 60)
                .offset(x: -45, y: -45)
            }
            .frame(maxWidth: 120)

            Text(self.carereceiver.name)
                .font(.headline)
        }
    }
}

#Preview {
    CarereceiverAvatarCell(carereceiver: Carereceiver(name: "Chantal", avatar: DesignKitAsset.Avatars.avatarsBoy4f.name, reinforcer: 2))
}
