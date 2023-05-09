// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesConfigurations: ObservableObject {

    @Published var preferred3AnswersLayout: AlternativeLayout = .basic
    @Published var preferred4AnswersLayout: AlternativeLayout = .basic

}
