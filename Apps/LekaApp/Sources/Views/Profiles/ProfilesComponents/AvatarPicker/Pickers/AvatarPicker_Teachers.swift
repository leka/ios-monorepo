// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AvatarPicker_Teachers: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var navigationVM: NavigationViewModel

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            AvatarPickerStore(selected: self.$selected)
                .onAppear {
                    self.selected = self.company.bufferTeacher.avatar
                }
                ._safeAreaInsets(EdgeInsets(top: 40, leading: 0, bottom: 20, trailing: 0))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .principal) { AvatarPicker_NavigationTitle() }
                    ToolbarItem(placement: .navigationBarLeading) { AvatarPicker_AdaptiveBackButton() }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AvatarPicker_ValidateButton(
                            selected: self.$selected,
                            action: {
                                self.company.setBufferAvatar(self.selected, for: .teacher)
                            }
                        )
                    }
                }
        }
        .toolbarBackground(self.navigationVM.showProfileEditor ? .visible : .automatic, for: .navigationBar)
        .preferredColorScheme(.light)
    }

    // MARK: Private

    @State private var selected: String = ""
}
