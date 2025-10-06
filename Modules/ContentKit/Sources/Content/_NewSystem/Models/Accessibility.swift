// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

// MARK: Accessibility

public struct Accessibility: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.focus = try container.decodeIfPresent(Focus.self, forKey: .focus)
        self.gesture = try container.decodeIfPresent(Gesture.self, forKey: .gesture)
    }

    // MARK: Public

    public enum Gesture: String, Decodable {
        case dragAndDrop = "drag_and_drop"
        case magicCard = "magic_card"
        case touchToSelect = "touch_to_select"
        case mixed
    }

    // swiftlint:disable identifier_name
    public enum Focus: String, Decodable {
        case ear
        case eye
        case robot
        case mixed
    }

    // swiftlint:enable identifier_name

    public let gesture: Gesture?
    public let focus: Focus?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case focus
        case gesture
    }
}
