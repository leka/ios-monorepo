// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import SwiftUI

struct CarereceiverAvatarCell: View {
    // MARK: Lifecycle

    init(carereceiver: Carereceiver, isSelected: Bool = false) {
        self.carereceiver = carereceiver
        self.isSelected = isSelected
    }

    // MARK: Internal

    let carereceiver: Carereceiver
    var isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: Avatars.iconToUIImage(icon: self.carereceiver.avatar))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(self.styleManager.accentColor!, lineWidth: self.isSelected ? 5 : 0)
                }
                .overlay {
                    Circle()
                        .strokeBorder(self.strokeColor, lineWidth: 2)
                        .background {
                            Circle()
                                .fill(Color(uiColor: UIColor.systemGray6))
                        }
                        .overlay {
                            Image(uiImage: self.carereceiver.reinforcer.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(5)
                        }
                        .frame(maxWidth: 60)
                        .offset(x: 60, y: 40)
                }
                .frame(maxWidth: 120)

            Text(self.carereceiver.username)
                .font(.headline)
                .lineLimit(2, reservesSpace: true)
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    private let strokeColor: Color = .init(light: UIColor.systemGray3, dark: UIColor.systemGray2)
}

#Preview {
    CarereceiverAvatarCell(
        carereceiver: Carereceiver(
            username: "Chantal",
            avatar: Avatars.categories[2].avatars[4],
            reinforcer: .fire
        )
    )
}
