// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import LogKit
import Version
import Yams

// MARK: - RobotAssets

public class RobotAssets {
    // MARK: Lifecycle

    private init() {
        self.container = Self.loadRobotAssets()
    }

    // MARK: Public

    public static var allRobotAssetsList: [RobotAsset] {
        shared.getAllRobotAssets()
    }

    public static func robotAsset(name: String) -> RobotAsset? {
        self.allRobotAssetsList.first(where: { $0.name == name })
    }

    // MARK: Private

    private struct RobotAssetsContainer: Codable {
        let list: [RobotAsset]
    }

    private static let shared: RobotAssets = .init()

    private let container: RobotAssetsContainer

    private static func loadRobotAssets() -> RobotAssetsContainer {
        if let fileURL = Bundle.module.url(forResource: "robot_assets", withExtension: "yml") {
            do {
                let yamlString = try String(contentsOf: fileURL, encoding: .utf8)
                let container = try YAMLDecoder().decode(RobotAssetsContainer.self, from: yamlString)
                return container
            } catch {
                logCK.error("Failed to read YAML file: \(error)")
                return RobotAssetsContainer(list: [])
            }
        } else {
            logCK.error("robot_assets.yml not found")
            return RobotAssetsContainer(list: [])
        }
    }

    private func getAllRobotAssets() -> [RobotAsset] {
        var allRobotAssets: [RobotAsset] = []

        for robotAsset in self.container.list {
            allRobotAssets.append(robotAsset)
        }

        return allRobotAssets
    }
}

// MARK: - RobotAsset

public struct RobotAsset: Codable, Identifiable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UInt16.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }

    // MARK: Public

    public let id: UInt16
    public let name: String
}

// MARK: Hashable

extension RobotAsset: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: Equatable

extension RobotAsset: Equatable {
    public static func == (lhs: RobotAsset, rhs: RobotAsset) -> Bool {
        lhs.id == rhs.id
    }
}
