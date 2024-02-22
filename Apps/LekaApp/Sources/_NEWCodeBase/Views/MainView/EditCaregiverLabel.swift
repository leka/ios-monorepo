// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - EditCaregiverLabel

struct EditCaregiverLabel: View {
    // MARK: Internal

    @Binding var isCaregiverPickerPresented: Bool

    var body: some View {
        VStack(alignment: .leading) {
            if let caregiver = self.rootOwnerViewModel.currentCaregiver {
                Button {
                    self.rootOwnerViewModel.isEditCaregiverViewPresented = true
                } label: {
                    HStack(spacing: 10) {
                        Image(uiImage: Avatars.iconToUIImage(icon: caregiver.avatar))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                            .clipShape(Circle())
                            .frame(maxWidth: 90)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(caregiver.name)
                                .font(.title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.primary)
                            Text(l10n.EditCaregiverProfile.buttonLabel)
                                .font(.footnote)
                                .foregroundStyle(self.styleManager.accentColor!)
                        }
                    }
                }
            } else {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 90)
                    .foregroundStyle(self.styleManager.accentColor!)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "person.2.gobackward") {
                    self.isCaregiverPickerPresented = true
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
}

// MARK: - l10n.ChangeCaregiverProfile

// swiftlint:disable line_length

extension l10n {
    enum EditCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.sidebar.edit_caregiver_profile.button_label", value: "Edit profile", comment: "The button label of caregiver profile editor")
    }

    enum SelectCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.sidebar.select_caregiver_profile.button_label", value: "Select profile", comment: "The button label of caregiver profile picker when no profile is selected")
    }
}

// swiftlint:enable line_length

#Preview {
    NavigationSplitView(sidebar: {
        List {
            EditCaregiverLabel(isCaregiverPickerPresented: .constant(false))

            Button {} label: {
                RobotConnectionLabel()
            }
            .listRowInsets(EdgeInsets(top: 0, leading: -8, bottom: -8, trailing: -8))

            Section("Information") {
                Label("What's new?", systemImage: "lightbulb.max")
                Label("Resources", systemImage: "book.and.wrench")
            }
        }
    }, detail: {
        EmptyView()
    })
    .onAppear {
        let rootOwnerViewModel = RootOwnerViewModel.shared
        rootOwnerViewModel.currentCaregiver = Caregiver(name: "Joe", avatar: Avatars.categories[0].avatars[2])
    }
}
