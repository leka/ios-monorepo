// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - General (user facing) update process states, errors

enum UpdateProcessStage {
    case initial
    case sendingUpdate
    case installingUpdate
}

enum UpdateProcessError: Error {
    case unknown
    case updateProcessNotAvailable
}

