// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesConfigurations: ObservableObject {

    @Published var preferred3AnswersLayout: AlternativeLayout = .basic
    @Published var preferred4AnswersLayout: AlternativeLayout = .basic
    @Published var currentActivityType: ActivityType = .touchToSelect
    @Published var currentDefaults: BaseDefaults? = TouchToSelect.one

    func setupExplorerVariations(forTemplate: Int) {
        if forTemplate == 2 {
            preferred3AnswersLayout = .basic
        } else if forTemplate == 3 {
            preferred3AnswersLayout = .inline
        } else if forTemplate == 4 {
            preferred4AnswersLayout = .basic
        } else if forTemplate == 5 {
            preferred4AnswersLayout = .inline
        }
    }
}
