// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

extension AccountCreationProcess {
    struct Step3: View {
        // MARK: Internal

        @Binding var selectedTab: Step

        var body: some View {
            VStack(spacing: 30) {
                Image(systemName: "figure.2.arms.open")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)

                Text(l10n.AccountCreationProcess.Step3.title)
                    .font(.headline)
                    .textCase(.uppercase)
                    .foregroundColor(DesignKitAsset.Colors.lekaOrange.swiftUIColor)

                Text(l10n.AccountCreationProcess.Step3.message)

                Button(String(l10n.AccountCreationProcess.Step3.createButton.characters)) {
                    self.isCarereceiverCreationPresented.toggle()
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: 400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: self.$isCarereceiverCreationPresented) {
                NavigationStack {
                    CreateCarereceiverView(onClose: {
                        withAnimation {
                            self.selectedTab = .final
                        }
                    })
                    .navigationBarTitleDisplayMode(.inline)
                    .interactiveDismissDisabled()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            self.selectedTab = .final
                        }
                    } label: {
                        Text(l10n.AccountCreationProcess.Step3.skipButton)
                    }

                    Spacer()
                }
            }
        }

        // MARK: Private

        @State private var isCarereceiverCreationPresented: Bool = false
    }
}

#Preview {
    AccountCreationProcess.Step3(selectedTab: .constant(.carereceiverCreation))
}
