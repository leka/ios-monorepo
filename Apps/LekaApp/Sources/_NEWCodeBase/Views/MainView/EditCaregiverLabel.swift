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
                    self.navigation.sheetContent = .createCaregiver
                } label: {
                    VStack(spacing: 20) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundStyle(self.styleManager.accentColor!)
                            .frame(width: 125, height: 125)
                            .overlay(
                                Circle()
                                    .stroke(self.styleManager.accentColor!, lineWidth: 2)
                            )
                        Text(l10n.AddFirstCaregiverProfile.buttonLabel)
                            .foregroundStyle(self.styleManager.accentColor!)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
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
                    self.navigation.sheetContent = .caregiverPicker
                }
            }
        }
        .onReceive(self.caregiverManagerViewModel.$currentCaregiver) { caregiverToEdit in
            // TODO: (@macteuts) - Remove fetch when listeners are implemented
            self.caregiverManager.fetchAllCaregivers()
            self.carereceiverManager.fetchAllCarereceivers()
            if self.navigation.sheetContent == nil, self.navigation.fullScreenCoverContent == nil {
                if caregiverToEdit == nil {
                    self.navigation.sheetContent = .caregiverPicker
                }
            }
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var navigation: Navigation = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    // TODO: (@macteuts) - remove managers when listeners are implemented
    private var caregiverManager: CaregiverManager = .shared
    private var carereceiverManager: CarereceiverManager = .shared
}

// MARK: - l10n.ChangeCaregiverProfile

// swiftlint:disable line_length

extension l10n {
    enum EditCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.sidebar.edit_caregiver_profile.button_label", value: "Edit profile", comment: "The button label of caregiver profile editor")
    }

    enum AddFirstCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.sidebar.add_first_caregiver_profile.button_label", value: "Create your first caregiver profile", comment: "The button label of create first profile when no profile is created")
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
        let caregiverManagerViewModel = CaregiverManagerViewModel()
        caregiverManagerViewModel.currentCaregiver = Caregiver(
            firstName: "Joe",
            lastName: "Bidjobba",
            avatar: Avatars.categories[0].avatars[2]
        )
    }
}
