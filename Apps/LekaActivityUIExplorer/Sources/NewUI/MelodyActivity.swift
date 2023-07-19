// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import GameEngineKit
import SwiftUI

let notes: [MusicalColor] = [.la, .si, .do, .re, .fa]
let melodyData = MusicalGameplayData(notes: notes)

struct MelodyActivity: View {
    let gameplay = GameplaySelectTheRightMelody(rightAnswers: melodyData.colors)

    var body: some View {
        SevenTilesXylophoneView(gameplay: gameplay)
    }
}

struct MelodyActivity_Previews: PreviewProvider {
    static var previews: some View {
        MelodyActivity()
    }
}
