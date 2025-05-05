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

    var body: some View {
        VStack(alignment: .leading) {
            if let caregiver = self.caregiverManagerViewModel.currentCaregiver {
                Button {
                    self.navigation.sheetContent = .editCaregiver
                } label: {
                    HStack(spacing: 10) {
                        Image(uiImage: Avatars.iconToUIImage(icon: caregiver.avatar))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(DesignKitAsset.Colors.blueGray.swiftUIColor)
                            .clipShape(Circle())
                            .frame(maxWidth: 90)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(caregiver.firstName)
                                .font(.title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.primary)
                            Text(caregiver.lastName)
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.secondary)
                            Text(l10n.EditCaregiverProfile.buttonLabel)
                                .font(.footnote)
                                .foregroundStyle(self.styleManager.accentColor!)
                        }
                    }
                }
            } else if self.caregiverManagerViewModel.caregivers.isEmpty {
                Button {
                    self.navigation.sheetContent = .caregiverPicker
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 90)
                            .foregroundStyle(self.styleManager.accentColor!)

                        Text(l10n.AddFirstCaregiverProfile.buttonLabel)
                            .foregroundStyle(self.styleManager.accentColor!)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            } else {
                Button {
                    self.navigation.sheetContent = .caregiverPicker
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 90)
                            .foregroundStyle(self.styleManager.accentColor!)

                        Text(l10n.SelectCaregiverProfile.buttonLabel)
                            .foregroundStyle(self.styleManager.accentColor!)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "person.2.gobackward") {
                    self.navigation.sheetContent = .caregiverPicker
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared

    @State private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var navigation: Navigation = .shared
}

// MARK: - l10n.ChangeCaregiverProfile

// swiftlint:disable line_length

extension l10n {
    enum EditCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.edit_caregiver_profile.button_label", value: "Edit profile", comment: "The button label of caregiver profile editor")
    }

    enum SelectCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.select_caregiver_profile.button_label", value: "Select Caregiver", comment: "The button label of select caregiver profile")
    }

    enum AddFirstCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.add_first_caregiver_profile.button_label", value: "Create First Caregiver", comment: "The button label of create first profile when no profile is created")
    }
}

// swiftlint:enable line_length

#Preview {
    NavigationSplitView(sidebar: {
        List {
            EditCaregiverLabel()

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
        let caregiverManager = CaregiverManager.shared
        let caregiver = Caregiver(
            firstName: "Joe",
            lastName: "Bidjobba",
            avatar: Avatars.categories[0].avatars[2]
        )
        caregiverManager.setCurrentCaregiver(to: caregiver)
    }
}
