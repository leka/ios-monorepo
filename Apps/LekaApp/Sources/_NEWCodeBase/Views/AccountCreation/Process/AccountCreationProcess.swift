// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import SwiftUI

enum AccountCreationProcess {
    struct NavigationTitle: View {
        var body: some View {
            Text(l10n.AccountCreationProcess.navigationTitle)
                .font(.headline)
        }
    }

    enum Step: Hashable {
        case intro
        case caregiverCreation
        case carereceiverCreation
        case final
    }

    struct CarouselView: View {
        // MARK: Internal

        var body: some View {
            TabView(selection: self.$selectedTab) {
                Step1(selectedTab: self.$selectedTab)
                    .tag(Step.intro)
                Step2(selectedTab: self.$selectedTab)
                    .tag(Step.caregiverCreation)
                Step3(selectedTab: self.$selectedTab)
                    .tag(Step.carereceiverCreation)
                Step4()
                    .tag(Step.final)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    NavigationTitle()
                }
            }
        }

        // MARK: Private

        @State private var selectedTab: Step = .intro
    }
}
