// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

struct MelodyActivity: View {
    let gameplay = MelodyGameplay(song: kListOfMelodySongsAvailable[0])

    var body: some View {
        MelodyView(gameplay: gameplay)
    }
}

struct MelodyActivity_Previews: PreviewProvider {
    static var previews: some View {
        MelodyActivity()
    }
}
