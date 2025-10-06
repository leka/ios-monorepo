// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: Accessibility

public struct Accessibility: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.gesture = try container.decode(Gesture.self, forKey: .gesture)
        self.focus = try container.decodeIfPresent(Focus.self, forKey: .focus)
    }

    // MARK: Public

    public enum Gesture: String, Codable {
        case dragAndDrop = "drag_and_drop"
        case magicCard = "magic_card"
        case touchToSelect = "touch_to_select"
        case mixed
    }

    // swiftlint:disable identifier_name
    public enum Focus: String, Codable {
        case ear
        case eye
        case robot
        case mixed
    }

    // swiftlint:enable identifier_name

    public let gesture: Gesture
    public let focus: Focus?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case focus
        case gesture
    }
}
