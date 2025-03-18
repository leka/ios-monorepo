// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

public enum NewExerciseInterface: Decodable, Equatable {
    case general(GeneralInterface)
    case specialized(SpecializedInterface)

    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        if let generalCase = GeneralInterface(rawValue: value) {
            self = .general(generalCase)
            return
        }

        if let specializedCase = SpecializedInterface(rawValue: value) {
            self = .specialized(specializedCase)
            return
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unknown interface type: \(value)"
        )
    }

    // MARK: Public

    public enum GeneralInterface: String, Decodable {
        case dragAndDropGrid
        case dragAndDropGridWithZones
        case dragAndDropOneToOne
        case magicCards
        case memory
        case touchToSelect
    }

    public enum SpecializedInterface: String, Decodable {
        case danceFreeze
        case superSimon
        case gamepadJoyStickColorPad
        case gamepadArrowPadColorPad
        case gamepadColorPad
        case gamepadArrowPad
        case hideAndSeek
        case musicalInstruments
        case melody
        case pairing
        case colorMusicPad
        case colorMediator
    }
}
