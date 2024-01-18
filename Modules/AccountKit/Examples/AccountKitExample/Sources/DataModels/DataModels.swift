// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - UserType

public enum UserType: Int, Codable, CaseIterable {
    case carereceiver
    case caregiver
}

// MARK: - Profile

protocol Profile: Identifiable, Codable, Hashable {
    var id: String { get }
    var type: UserType { get }
    var name: String { get set }
    var avatar: String { get set }
}

// MARK: - Company

public struct Company: Codable, Identifiable {
    public var id: String
    public var email: String
    public var name: String
    public var caregivers: [Caregiver]
    public var carereceivers: [Carereceiver]
}

// MARK: - Caregiver

public struct Caregiver: Profile {
    public var id: String
    public var type = UserType.caregiver
    public var name: String
    public var avatar: String
    public var jobs: [String]
}

// MARK: - Carereceiver

public struct Carereceiver: Profile {
    public var id: String
    public var type = UserType.carereceiver
    public var name: String
    public var avatar: String
    public var reinforcer: Int
}
