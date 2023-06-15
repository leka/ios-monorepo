// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

class GameLayoutTemplatesConfigurations: ObservableObject {

    @Published var currentActivityType: ActivityType = .touchToSelect
    @Published var currentInterface: GameLayout = .touch1  // put this in defaults?
    @Published var currentDefaults: BaseDefaults? = TouchToSelect.one

}
