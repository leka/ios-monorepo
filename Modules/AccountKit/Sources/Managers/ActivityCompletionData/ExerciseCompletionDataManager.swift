// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import Foundation

public class ExerciseCompletionDataManager {
    // MARK: Lifecycle

    private init() {}

    // MARK: Public

    public static let shared = ExerciseCompletionDataManager()

    public func createCompletionData(startTimestamp: Date?, endTimestamp: Date?, payload: some Codable) -> ExerciseCompletionData {
        let encodedPayload = payload.encodeToString()
        return ExerciseCompletionData(startTimestamp: startTimestamp, endTimestamp: endTimestamp, payload: encodedPayload)
    }

    public func encodeCompletionData(_ data: [[ExerciseCompletionData]]) -> String {
        data.encodeToString()
    }

    public func decodeCompletionData(from jsonString: String) -> [[ExerciseCompletionData]]? {
        try? [[ExerciseCompletionData]].decodeFromString(jsonString)
    }
}
