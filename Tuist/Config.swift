// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToManifest("../../Plugins/ios-monorepo")),
    ]
)
