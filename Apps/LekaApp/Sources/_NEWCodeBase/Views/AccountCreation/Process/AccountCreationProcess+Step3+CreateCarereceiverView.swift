// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CreateCarereceiverView

extension AccountCreationProcess {
    struct CreateCarereceiverView: View {
        // MARK: Internal

        @Binding var selectedTab: Step
        @Binding var isPresented: Bool

        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 40) {
                        self.avatarNavigationLink

                        TextFieldDefault(label: String(l10n.AccountCreationProcess.Step3.CarereceiverCreation.carereceiverNameLabel.characters),
                                         entry: self.$rootOwnerViewModel.bufferCarereceiver.name)
                            .frame(width: 400)

                        Button(String(l10n.AccountCreationProcess.Step3.CarereceiverCreation.registerProfilButton.characters)) {
                            withAnimation {
                                self.isPresented.toggle()
                                self.selectedTab = .final
                            }
                            // TODO: (@team) : add the carereceiver profile to the account
                            // TODO: (@team) : assign the carereceiver profile as the current selected one
                        }
                        .disabled(self.rootOwnerViewModel.bufferCarereceiver.name.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .navigationTitle(String(l10n.AccountCreationProcess.Step3.CarereceiverCreation.title.characters))
                }
            }
        }

        // MARK: Private

        @ObservedObject private var rootOwnerViewModel = RootOwnerViewModel.shared

        private var avatarNavigationLink: some View {
            NavigationLink {
                AvatarPicker(avatar: self.$rootOwnerViewModel.bufferCarereceiver.avatar)
            } label: {
                VStack(spacing: 15) {
                    AvatarPicker.ButtonLabel(image: self.rootOwnerViewModel.bufferCarereceiver.avatar)
                    Text(l10n.AccountCreationProcess.Step3.CarereceiverCreation.avatarChoiceButton)
                        // TODO: (@ui/ux) - Design System - replace with Leka font
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    AccountCreationProcess.CreateCarereceiverView(selectedTab: .constant(.carereceiverCreation), isPresented: .constant(true))
}
