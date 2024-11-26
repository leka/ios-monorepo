// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebaseCrashlytics

public class CrashlyticsManager {
    public static func log(message: String) {
        Crashlytics.crashlytics().log(message)
    }

    public static func setCustomKey(_ key: String, value: Any) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }

    public static func setUserID(_ userID: String) {
        Crashlytics.crashlytics().setUserID(userID)
    }

    public static func recordError(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
