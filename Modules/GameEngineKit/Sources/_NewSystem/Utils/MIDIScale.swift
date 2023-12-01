// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AudioKit

enum MIDIScale: String {
    case majorPentatonic
    case majorHeptatonic
    case majorOctatonic

    var notes: [MIDINoteNumber] {
        switch self {
            case .majorPentatonic:
                return [24, 26, 28, 31, 33]
            case .majorHeptatonic:
                return [24, 26, 28, 29, 31, 33, 35]
            case .majorOctatonic:
                return [24, 26, 28, 29, 31, 33, 35, 36]
        }
    }
}
