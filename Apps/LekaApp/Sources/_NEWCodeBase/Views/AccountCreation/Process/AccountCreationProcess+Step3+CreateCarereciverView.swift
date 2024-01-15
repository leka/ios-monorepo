// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateUserProfileView

extension AccountCreationProcess {
    struct CreateUserProfileView: View {
        // MARK: Internal

        @EnvironmentObject var viewRouter: ViewRouter

        var body: some View {
            VStack {
                Text("To implement on Teacher profiles structure ready !")
                    .edgesIgnoringSafeArea(.top)
                    .navigationDestination(isPresented: self.$navigateToStepFinal) {
                        AccountCreationProcess.StepFinal()
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            NavigationTitle()
                        }
                    }

                Button("Go final step !") {
                    self.navigateToStepFinal.toggle()
                }
            }
        }

        // MARK: Private

        @State private var navigateToStepFinal: Bool = false
    }
}

#Preview {
    AccountCreationProcess.CreateUserProfileView()
}
