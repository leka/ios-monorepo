// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - CreateTeacherProfileView

extension AccountCreationProcess {
    struct CreateCaregiverView: View {
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

                Button("Go to step 3") {
                    withAnimation {
                        self.isPresented.toggle()
                        self.selectedTab = .carereceiverCreation
                    }
                }
            }
        }
    }
}

#Preview {
    AccountCreationProcess.CreateCaregiverView(selectedTab: .constant(.caregiverCreation), isPresented: .constant(true))
}
