// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - DatabaseCollection

public enum DatabaseCollection: String {
    case activityCompletionData = "ACTIVITY_COMPLETION_DATA"
    case caregivers = "CAREGIVERS"
    case carereceivers = "CARE_RECEIVERS"
    case sharedLibraries = "SHARED_LIBRARIES"
    case rootAccounts = "ROOT_ACCOUNTS"
}

// MARK: - SharedLibrarySubCollection

public enum SharedLibrarySubCollection: String {
    case curriculums = "CURRICULUMS"
    case activities = "ACTIVITIES"
    case stories = "STORIES"
}
