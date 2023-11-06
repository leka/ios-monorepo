// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct DanceFreezeActivity: View {
    @StateObject private var gameplay = DanceFreezeGameplay()

    var body: some View {
        DanceFreezeView(gameplay: gameplay)
    }
}

struct DanceFreezeActivity_Previews: PreviewProvider {
    static var previews: some View {
        DanceFreezeActivity()
    }
}
