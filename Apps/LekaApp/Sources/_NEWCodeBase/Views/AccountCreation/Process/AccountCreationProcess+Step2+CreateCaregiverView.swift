// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CreateCaregiverView

extension AccountCreationProcess {
    struct CreateCaregiverView: View {
        // MARK: Internal

        @Binding var selectedTab: Step
        @Binding var isPresented: Bool

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 40) {
                        self.avatarNavigationLink

                        TextFieldDefault(label: String(l10n.AccountCreationProcess.Step2.CaregiverCreation.caregiverNameLabel.characters),
                                         entry: self.$rootOwnerViewModel.bufferCaregiver.name)
                            .frame(width: 400)

                        self.professionNavigationLink

                        Button(String(l10n.AccountCreationProcess.Step2.CaregiverCreation.registerProfilButton.characters)) {
                            withAnimation {
                                self.isPresented.toggle()
                                self.selectedTab = .carereceiverCreation
                            }
                            // TODO: (@team) : add the caregiver profile to the account
                            // TODO: (@team) : assign the caregiver profile as the current selected one
                        }
                        .disabled(self.rootOwnerViewModel.bufferCaregiver.name.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .navigationTitle(String(l10n.AccountCreationProcess.Step2.CaregiverCreation.title.characters))
                }
            }
        }

        // MARK: Private

        @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared

        private var avatarNavigationLink: some View {
            NavigationLink {
                AvatarPicker(avatar: self.$rootOwnerViewModel.bufferCaregiver.avatar)
            } label: {
                VStack(spacing: 15) {
                    AvatarPicker.ButtonLabel(image: self.rootOwnerViewModel.bufferCaregiver.avatar)
                    Text(l10n.AccountCreationProcess.Step2.CaregiverCreation.avatarChoiceButton)
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.headline)
                }
            }
        }

        private var professionNavigationLink: some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(l10n.AccountCreationProcess.Step2.CaregiverCreation.professionLabel)
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.body)

                    Spacer()

                    NavigationLink {
                        ProfessionPicker()
                    } label: {
                        Label(String(l10n.AccountCreationProcess.Step2.CaregiverCreation.professionAddButton.characters), systemImage: "plus")
                    }
                }

                if !self.rootOwnerViewModel.bufferCaregiver.professions.isEmpty {
                    ForEach(self.rootOwnerViewModel.bufferCaregiver.professions, id: \.self) { profession in
                        ProfessionPicker.ProfessionTag(profession: profession)
                    }
                }
            }
            .frame(width: 400)
        }
    }
}

#Preview {
    AccountCreationProcess.CreateCaregiverView(selectedTab: .constant(.caregiverCreation), isPresented: .constant(true))
}
