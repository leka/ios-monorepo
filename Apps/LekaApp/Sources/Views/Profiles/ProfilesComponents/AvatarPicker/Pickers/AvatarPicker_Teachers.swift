// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AvatarPicker_Teachers: View {

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var viewRouter: ViewRouter

    @State private var selected: String = ""

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            AvatarPickerStore(selected: $selected)
                .onAppear {
                    selected = company.bufferTeacher.avatar
                }
                ._safeAreaInsets(EdgeInsets(top: 40, leading: 0, bottom: 20, trailing: 0))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .principal) { AvatarPicker_NavigationTitle() }
                    ToolbarItem(placement: .navigationBarLeading) { AvatarPicker_AdaptiveBackButton() }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        AvatarPicker_ValidateButton(
                            selected: $selected,
                            action: {
                                company.setBufferAvatar(selected, for: .teacher)
                            })
                    }
                }
        }
        .toolbarBackground(viewRouter.currentPage == .profiles ? .visible : .automatic, for: .navigationBar)
        .preferredColorScheme(.light)
    }
}
