// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import FirebasePerformance

public class PerformanceManager {
    public static func startTrace(name: String) -> Trace? {
        let trace = Performance.startTrace(name: name)
        trace?.start()
        return trace
    }

    public static func stopTrace(_ trace: Trace?) {
        trace?.stop()
    }

    public static func setMetric(_ trace: Trace?, name: String, value: Int) {
        trace?.incrementMetric(name, by: Int64(value))
    }
}
