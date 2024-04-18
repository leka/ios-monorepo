// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit

extension l10n {
    enum DanceFreezeView {
        static let instructions = LocalizedString("game_engine_kit.dance_freeze_view.instructions",
                                                  bundle: GameEngineKitResources.bundle,
                                                  value: "Dance with Leka to the music and act like a statue when he stops",
                                                  comment: "DanceFreezeView instructions")

        static let musicSelectionTitle = LocalizedString("game_engine_kit.dance_freeze_view.music_selection_title",
                                                         bundle: GameEngineKitResources.bundle,
                                                         value: "Music selection",
                                                         comment: "DanceFreezeView music selection title")

        static let motionSelectionTitle = LocalizedString("game_engine_kit.dance_freeze_view.motion_selection_title",
                                                          bundle: GameEngineKitResources.bundle,
                                                          value: "Motion type",
                                                          comment: "DanceFreezeView motion selection title")

        static let rotationButtonLabel = LocalizedString("game_engine_kit.dance_freeze_view.rotation_button_label",
                                                         bundle: GameEngineKitResources.bundle,
                                                         value: "Rotation",
                                                         comment: "DanceFreezeView rotation button label")

        static let movementButtonLabel = LocalizedString("game_engine_kit.dance_freeze_view.movement_button_label",
                                                         bundle: GameEngineKitResources.bundle,
                                                         value: "Movement",
                                                         comment: "DanceFreezeView movement button label")

        static let manualButtonLabel = LocalizedString("game_engine_kit.dance_freeze_view.manual_button_label",
                                                       bundle: GameEngineKitResources.bundle,
                                                       value: "Play - Manual mode",
                                                       comment: "DanceFreezeView manual button label")

        static let autoButtonLabel = LocalizedString("game_engine_kit.dance_freeze_view.auto_button_label",
                                                     bundle: GameEngineKitResources.bundle,
                                                     value: "Play - Auto mode",
                                                     comment: "DanceFreezeView auto button label")
    }
}
