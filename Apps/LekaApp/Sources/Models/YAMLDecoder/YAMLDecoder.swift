// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

// MARK: - YamlFileDecodable

protocol YamlFileDecodable {
    func decodeYamlFile<T: Decodable>(withName name: String, toType: T.Type) throws -> T
}

extension YamlFileDecodable {
    func decodeYamlFile<T: Decodable>(withName name: String, toType: T.Type) throws -> T {
        guard let path = Bundle.main.path(forResource: name, ofType: "yml") else {
            print(name)
            throw CustomError.failedToGetFilePath
        }

        let yamlString = try String(contentsOfFile: path)
        let decoder = YAMLDecoder()
        let decoded = try decoder.decode(T.self, from: yamlString)
        return decoded
    }
}

// MARK: - CustomError

enum CustomError: Error, CustomStringConvertible {
    case failedToGetFilePath

    // MARK: Internal

    var description: String {
        switch self {
            case .failedToGetFilePath: "Unable to get the path to the Yaml file!"
        }
    }
}

// MARK: - YamlFiles

struct YamlFiles: RawRepresentable, Hashable {
    // MARK: Lifecycle

    init?(rawValue: String) {
        self.rawValue = rawValue
    }

    init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Internal

    var rawValue: String
}

// MARK: - CurriculumCategories

enum CurriculumCategories: String, CaseIterable {
    case emotionRecognition = "emotion_recognition-curriculums-list"
    case categorization = "categorization_curriculums-list"
    case receptiveLanguage = "receptive-language_curriculums-list"
}
