// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import Yams

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

// MARK: - Custom Errors

enum CustomError: Error, CustomStringConvertible {
    case failedToGetFilePath

    var description: String {
        switch self {
            case .failedToGetFilePath: return "Unable to get the path to the Yaml file!"
        }
    }
}

// MARK: - Handling Yaml files in a type-safe manner, when possible!

struct YamlFiles: RawRepresentable, Hashable {
    var rawValue: String

    init?(rawValue: String) {
        self.rawValue = rawValue
    }
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension YamlFiles {
    static let YAMLCurriculumList = Self("emotion_recognition-curriculums-list")
    //    static let EmotionRecognitionList = Self("emotion_recognition-curriculums-list")
    //    static let CategorizationList = Self("categorization_curriculums-list")
    //    static let ReceptiveLanguageList = Self("receptive-language_curriculums-list")
}

enum CurriculumCategories: String, CaseIterable {
    case emotionRecognition = "emotion_recognition-curriculums-list"
    case categorization = "categorization_curriculums-list"
    case receptiveLanguage = "receptive-language_curriculums-list"
}
