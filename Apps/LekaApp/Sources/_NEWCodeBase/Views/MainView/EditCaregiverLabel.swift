// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import RobotKit
import SwiftUI

// MARK: - EditCaregiverLabel

struct EditCaregiverLabel: View {
    // MARK: Internal

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if let caregiver = self.rootOwnerViewModel.currentCaregiver {
                Button {
                    self.rootOwnerViewModel.isEditCaregiverViewPresented = true
                } label: {
                    CaregiverAvatarCell(caregiver: caregiver)
                        .frame(maxWidth: 80)
                }

                Button {
                    self.rootOwnerViewModel.isCaregiverPickerViewPresented = true
                } label: {
                    Label(String(l10n.ChangeCaregiverProfile.buttonLabel.characters), systemImage: "person.2.circle")
                }
                .buttonStyle(.bordered)
            } else {
                Button {
                    self.rootOwnerViewModel.isCaregiverPickerViewPresented = true
                } label: {
                    UnselectedProfileLabel()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared
}

// MARK: - UnselectedProfileLabel

struct UnselectedProfileLabel: View {
    // MARK: Internal

    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundStyle(self.styleManager.accentColor!)

            Text(l10n.SelectCaregiverProfile.buttonLabel)
                .foregroundStyle(self.styleManager.accentColor!)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: Private

    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.ChangeCaregiverProfile

// swiftlint:disable line_length

extension l10n {
    enum ChangeCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.sidebar.change_caregiver_profile.button_label", value: "Change profile", comment: "The button label of caregiver profile picker")
    }

    enum SelectCaregiverProfile {
        static let buttonLabel = LocalizedString("lekapp.sidebar.select_caregiver_profile.button_label", value: "Select profile", comment: "The button label of caregiver profile picker when no profile is selected")
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
}
