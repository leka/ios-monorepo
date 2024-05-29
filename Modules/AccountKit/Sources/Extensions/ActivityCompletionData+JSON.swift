// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

public extension ActivityCompletionData {
    static func encodeCompletionData(from exercises: [[ExerciseCompletionData]]) -> String {
        do {
            let jsonData = try JSONEncoder().encode(exercises)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            // Add Log
            return ""
        }
    }

    static func decodeCompletionData(from jsonString: String) throws -> [[ExerciseCompletionData]] {
        let jsonData = jsonString.data(using: .utf8)!
        return try JSONDecoder().decode([[ExerciseCompletionData]].self, from: jsonData)
    }
}
