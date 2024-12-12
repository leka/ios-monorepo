// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit

enum MIDIScale: String {
    case majorPentatonic
    case majorHeptatonic
    case majorPentatonicDoubleOctave

    // MARK: Internal

    var notes: [MIDINoteNumber] {
        switch self {
            case .majorPentatonic:
                [24, 26, 28, 31, 33]
            case .majorHeptatonic:
                [24, 26, 28, 29, 31, 33, 35, 36]
            case .majorPentatonicDoubleOctave:
                [24, 26, 28, 31, 33, 36, 38, 40, 43, 45]
        }
    }
}
