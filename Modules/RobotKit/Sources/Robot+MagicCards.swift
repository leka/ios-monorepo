// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import BLEKit
import Combine

extension Robot {
    func registerMagicCardsNotificationCallback() {
        let characteristic = CharacteristicModelNotifying(
            characteristicUUID: BLESpecs.MagicCard.Characteristics.idLanguage,
            serviceUUID: BLESpecs.MagicCard.service,
            onNotification: { data in
                if let data {
                    let id = data.dropLast().map { UInt16($0) }.reduce(0) { $0 << 8 + $1 }
                    let language = MagicCard.Language(rawValue: data.last!)!

                    let card = MagicCard.from(id: id, language: language)!
                    self.magicCard.send(card)

                    log.trace("🤖 magicCard: language \(language.rawValue), id \(String(format: "%04X", id))")
                }
            }
        )

        connectedPeripheral?.notifyingCharacteristics.insert(characteristic)
    }

    func registerMagicCardsReadCallback() {
        let characteristic = CharacteristicModelReadOnly(
            characteristicUUID: BLESpecs.MagicCard.Characteristics.idLanguage,
            serviceUUID: BLESpecs.MagicCard.service,
            onRead: { data in
                if let data {
                    let id = data.dropLast().map { UInt16($0) }.reduce(0) { $0 << 8 + $1 }
                    let language = MagicCard.Language(rawValue: data.last!)!

                    let card = MagicCard.from(id: id, language: language)!
                    self.magicCard.send(card)

                    log.trace("🤖 magicCard: language \(language.rawValue), id \(String(format: "%04X", id))")
                }
            }
        )

        connectedPeripheral?.readOnlyCharacteristics.insert(characteristic)
    }
}
