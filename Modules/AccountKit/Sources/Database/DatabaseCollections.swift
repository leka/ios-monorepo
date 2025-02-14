// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

// MARK: - DatabaseCollection

public enum DatabaseCollection: String {
    case activityCompletionData = "ACTIVITY_COMPLETION_DATA"
    case caregivers = "CAREGIVERS"
    case carereceivers = "CARE_RECEIVERS"
    case libraries = "LIBRARIES"
    case rootAccounts = "ROOT_ACCOUNTS"
}

// MARK: - LibrarySubCollection

public enum LibrarySubCollection: String {
    case curriculums = "CURRICULUMS"
    case activities = "ACTIVITIES"
    case stories = "STORIES"
    case favoriteActivities = "FAVORITE_ACTIVITIES"
}
