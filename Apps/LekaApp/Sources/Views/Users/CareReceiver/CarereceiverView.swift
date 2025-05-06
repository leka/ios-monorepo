// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverView

struct CarereceiverView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    @State var carereceiver: Carereceiver
    var styleManager: StyleManager = .shared

    var body: some View {
        VStack {
            Button {
                self.isEditCarereceiverViewPresented = true
            } label: {
                HStack(spacing: 20) {
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
                                    Image(uiImage: self.carereceiver.reinforcer.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(5)
                                }
                                .frame(maxWidth: 45)
                                .offset(x: 45, y: 35)
                        }
                    VStack(alignment: .leading, spacing: 0) {
                        Text(self.carereceiver.username)
                            .font(.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.primary)
                        Text(l10n.CarereceiverView.editProfileButtonLabel)
                            .font(.footnote)
                            .foregroundStyle(self.styleManager.accentColor!)
                    }
                }
            }
            .padding()
            .frame(maxHeight: 140)
            .sheet(isPresented: self.$isEditCarereceiverViewPresented) {
                NavigationStack {
                    EditCarereceiverView(modifiedCarereceiver: self.$carereceiver)
                        .logEventScreenView(screenName: "carereceiver_edit", context: .sheet)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

            Divider()

            Spacer()

            Image(systemName: "chart.xyaxis.line")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50)
            Text(l10n.CarereceiverView.availableSoonLabel)
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }

    // MARK: Private

    private let strokeColor: Color = .init(light: UIColor.systemGray3, dark: UIColor.systemGray2)
    @State private var isEditCarereceiverViewPresented = false
}

// MARK: - l10n.CarereceiverView

// swiftlint:disable line_length

extension l10n {
    enum CarereceiverView {
        static let availableSoonLabel = LocalizedString("lekapp.carereceiver_view.available_soon_label", value: "Your usage history will soon be available here.", comment: "Temporary content for carereceiver monitoring")

        static let editProfileButtonLabel = LocalizedString("lekapp.carereceiver_view.edit_profile_button_label", value: "Edit profile", comment: "The button label of carereceiver profile editor")
    }
}

// swiftlint:enable line_length

#Preview {
    CarereceiverView(carereceiver: Carereceiver(
        username: "Peet",
        avatar: Avatars.categories[0].avatars[0],
        reinforcer: .fire
    ))
}
