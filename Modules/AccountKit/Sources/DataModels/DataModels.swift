// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - Profile

public protocol Profile: Identifiable, Hashable {
    var id: String { get }
    var name: String { get set }
    var avatar: String { get set }
}

// MARK: - Company

public struct Company: Codable, Identifiable {
    // MARK: Lifecycle

    public init(id: String, email: String, name: String, caregivers: [Caregiver], carereceivers: [Carereceiver]) {
        self.id = id
        self.email = email
        self.name = name
        self.caregivers = caregivers
        self.carereceivers = carereceivers
    }

    // MARK: Public

    public var id: String
    public var email: String
    public var name: String
    public var caregivers: [Caregiver]
    public var carereceivers: [Carereceiver]
}

// MARK: - Caregiver

public struct Caregiver: Profile, Codable {
    // MARK: Lifecycle

    public init(id: String, name: String, avatar: String, jobs: [String]) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.jobs = jobs
    }

    // MARK: Public

    public var id: String
    public var name: String
    public var avatar: String
    public var jobs: [String]
}

// MARK: - Carereceiver

public struct Carereceiver: Profile, Codable {
    // MARK: Lifecycle

    public init(id: String, name: String, avatar: String, reinforcer: Int) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.reinforcer = reinforcer
    }

    // MARK: Public

    public var id: String
    public var name: String
    public var avatar: String
    public var reinforcer: Int
}
