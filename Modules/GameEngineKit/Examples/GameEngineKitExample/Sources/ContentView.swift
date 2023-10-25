// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

public enum ActivityList {
    public static let mixed: Activity = ContentKit.decodeActivity("activity-mixed")
    public static let touchToSelectOneAnswer: Activity = ContentKit.decodeActivity("activity-seq1-selection")
}

struct ContentView: View {

    @State var currentActivity: Activity?

    var body: some View {
        VStack(spacing: 30) {
            Button("Touch to select one answer") {
                currentActivity = ActivityList.touchToSelectOneAnswer
            }

            Button("Touch to select multple answers") {
                // TODO(@ladislas): change when implemented
                currentActivity = ActivityList.touchToSelectOneAnswer
            }

            Button("Mix of interfaces") {
                currentActivity = ActivityList.mixed
            }
        }
        .fullScreenCover(item: $currentActivity) {
            currentActivity = nil
        } content: { activity in
            ActivityView(viewModel: ActivityViewViewModel(activity: activity))
                .onLongPressGesture {
                    currentActivity = nil
                }
        }
        .buttonStyle(.borderedProminent)
    }

}

#Preview {
    ContentView()
}
