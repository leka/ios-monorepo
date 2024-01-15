// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateTeacherProfileView

extension AccountCreationProcess {
    struct CreateTeacherProfileView: View {
        // MARK: Internal

        @EnvironmentObject var viewRouter: ViewRouter

        var body: some View {
            VStack {
                Text("To implement on Teacher profiles structure ready !")
                    .edgesIgnoringSafeArea(.top)
                    .navigationDestination(isPresented: self.$navigateToStep3) {
                        AccountCreationProcess.Step3()
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            NavigationTitle()
                        }
                    }

                Button("Go to step 3") {
                    self.navigateToStep3.toggle()
                }
            }
        }

        // MARK: Private

        @State private var navigateToStep3: Bool = false
    }
}

#Preview {
    AccountCreationProcess.CreateTeacherProfileView()
}
