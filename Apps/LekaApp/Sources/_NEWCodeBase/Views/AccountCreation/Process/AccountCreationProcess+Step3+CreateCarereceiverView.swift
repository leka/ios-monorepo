// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateUserProfileView

extension AccountCreationProcess {
    struct CreateCarereceiverView: View {
        @Binding var selectedTab: Step
        @Binding var isPresented: Bool

        var body: some View {
            VStack {
                Text("To implement on Teacher profiles structure ready !")
                    .edgesIgnoringSafeArea(.top)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            NavigationTitle()
                        }
                    }

                Button("Go step 4 !") {
                    withAnimation {
                        self.isPresented.toggle()
                        self.selectedTab = .final
                    }
                }
            }
        }
    }
}

#Preview {
    AccountCreationProcess.CreateCarereceiverView(selectedTab: .constant(.carereceiverCreation), isPresented: .constant(true))
}
