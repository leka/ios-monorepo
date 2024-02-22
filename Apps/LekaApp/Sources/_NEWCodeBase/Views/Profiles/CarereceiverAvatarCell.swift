// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

struct CarereceiverAvatarCell: View {
    // MARK: Internal

    private let strokeColor: Color = .init(light: UIColor.systemGray3, dark: UIColor.systemGray2)

    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    let carereceiver: Carereceiver

    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: Avatars.iconToUIImage(icon: self.carereceiver.avatar))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .strokeBorder(self.strokeColor, lineWidth: 2)
                        .background {
                            Circle()
                                .fill(Color(uiColor: UIColor.systemGray6))
                        }
                        .overlay {
                            Image(uiImage: self.rootOwnerViewModel.getReinforcerFor(index: self.carereceiver.reinforcer))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                        }
                        .frame(maxWidth: 60)
                        .offset(x: 60, y: 40)
                }
                .frame(maxWidth: 120)

            Text(self.carereceiver.name)
                .font(.headline)
        }
    }
}

#Preview {
    CarereceiverAvatarCell(carereceiver: Carereceiver(name: "Chantal", avatar: Avatars.categories[2].avatars[4], reinforcer: 2))
}
