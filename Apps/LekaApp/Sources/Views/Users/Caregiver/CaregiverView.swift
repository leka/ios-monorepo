// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CaregiverView

struct CaregiverView: View {
    // MARK: Internal

    @Environment(\.dismiss) var dismiss
    var styleManager: StyleManager = .shared
    @State var caregiver: Caregiver

    var body: some View {
        VStack {
            Button {
                self.isEditCaregiverViewPresented = true
            } label: {
                HStack(spacing: 10) {
                    Image(uiImage: Avatars.iconToUIImage(icon: self.caregiver.avatar))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 0) {
                        Text(self.caregiver.firstName)
                            .font(.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.primary)
                        Text(self.caregiver.lastName)
                            .font(.caption)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .foregroundColor(.secondary)
                        Text(l10n.CaregiverView.editProfileButtonLabel)
                            .font(.footnote)
                            .foregroundStyle(self.styleManager.accentColor!)
                    }
                }
            }
            .padding()
            .frame(maxHeight: 140)
            .sheet(isPresented: self.$isEditCaregiverViewPresented) {
                NavigationStack {
                    EditCaregiverView(caregiver: self.caregiver)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .onChange(of: self.caregiverManagerViewModel.caregivers) {
                guard !self.caregiverManagerViewModel.caregivers.isEmpty else { return }
                self.caregiver = self.caregiverManagerViewModel.caregivers.first(where: { $0.id == self.caregiver.id })!
            }

            Divider()

            Spacer()

            Image(systemName: "chart.xyaxis.line")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 50)
            Text(l10n.CaregiverView.availableSoonLabel)
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Spacer()
        }
    }

    // MARK: Private

    private let strokeColor: Color = .init(light: UIColor.systemGray3, dark: UIColor.systemGray2)
    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()
    @State private var isEditCaregiverViewPresented = false
}

// MARK: - l10n.CaregiverView

// swiftlint:disable line_length

extension l10n {
    enum CaregiverView {
        static let availableSoonLabel = LocalizedString("lekapp.caregiver_view.available_soon_label", value: "Your usage history will soon be available here.", comment: "Temporary content for caregiver monitoring")

        static let editProfileButtonLabel = LocalizedString("lekapp.carereceiver_view.edit_profile_button_label", value: "Edit profile", comment: "The button label of carereceiver profile editor")
    }
}

// swiftlint:enable line_length

#Preview {
    CaregiverView(caregiver: Caregiver(
        firstName: "Roger",
        lastName: "Peter",
        avatar: Avatars.categories[0].avatars[2]
    ))
}
