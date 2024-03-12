// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step2: View {
        // MARK: Internal

        @Binding var selectedTab: Step

        var body: some View {
            VStack(spacing: 30) {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)

                Text(l10n.AccountCreationProcess.Step2.title)
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(.orange)

                Text(l10n.AccountCreationProcess.Step2.message)

                Button(String(l10n.AccountCreationProcess.Step2.createButton.characters)) {
                    withAnimation {
                        self.isCaregiverCreationPresented.toggle()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: self.$isCaregiverCreationPresented) {
                CreateCaregiverView(onCreated: { caregiver in
                    self.caregiverManager.setCurrentCaregiver(to: caregiver)
                })
            }
            .onReceive(self.caregiverManagerViewModel.$currentCaregiver) {
                guard $0 != nil else {
                    // TODO(@macteuts): deal with activity indicator && failed creation here
                    return
                }
                self.selectedTab = .carereceiverCreation
            }
        }

        // MARK: Private

        @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

        @State private var isCaregiverCreationPresented: Bool = false
        private let caregiverManager: CaregiverManager = .shared
    }
}

#Preview {
    AccountCreationProcess.Step2(selectedTab: .constant(AccountCreationProcess.Step.caregiverCreation))
}
