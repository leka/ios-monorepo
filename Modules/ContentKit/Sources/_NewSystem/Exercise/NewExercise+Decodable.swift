// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LocalizationKit
import UtilsKit
import Yams

// MARK: - NewExercise + Decodable

extension NewExercise: Decodable {
    enum CodingKeys: String, CodingKey {
        case localizedInstructions = "instructions"
        case interface
        case gameplay
        case action
        case payload
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.interface = try container.decode(NewExerciseInterface.self, forKey: .interface)
        self.gameplay = try container.decodeIfPresent(NewExerciseGameplay.self, forKey: .gameplay)
        self.action = try container.decodeIfPresent(NewExerciseAction.self, forKey: .action)

        if let options = try container.decodeIfPresent(NewExerciseOptions.self, forKey: .options) {
            self.options = options
        } else {
            self.options = NewExerciseOptions()
        }

        if let localizedInstructions = try? container.decode([LocalizedInstructions].self, forKey: .localizedInstructions) {
            let availableLocales = localizedInstructions.map(\.locale)

            let currentLocale = availableLocales.first(where: {
                $0.language.languageCode == LocalizationKit.l10n.language
            }) ?? Locale(identifier: "en_US")

            self.instructions = localizedInstructions.first(where: { $0.locale == currentLocale })?.value
        } else {
            self.instructions = nil
        }

        let data = try container.decodeIfPresent(AnyCodable.self, forKey: .payload)
        self.payload = try JSONEncoder().encode(data)
    }

    public init?(yaml yamlString: String) {
        if let exercise = try? YAMLDecoder().decode(NewExercise.self, from: yamlString) {
            self = exercise
        } else {
            return nil
        }
    }
}
