// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI

// MARK: - WorkInProgress

struct WorkInProgress: Identifiable {
    var id = UUID().uuidString
    var name: String = ""
}

// MARK: - WIPListView

struct WIPListView: View {
    @State var currentActivity: WorkInProgress?

    let WIPActivities: [WorkInProgress] = [
        WorkInProgress(name: "Sort images"),
        WorkInProgress(name: "Sort colors"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(self.WIPActivities, id: \.id) { activity in
                    Button(activity.name) {
                        self.currentActivity = activity
                    }
                }
            }
            .fullScreenCover(item: self.$currentActivity) {
                self.currentActivity = nil
            } content: { activity in
                if activity.name == "Sort images" {
                    Text("Sort images!")
                        .font(.largeTitle)
                        .bold()
                } else {
                    Text("Sort colors!")
                        .font(.largeTitle)
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("List of Works in Progress")
    }
}

#Preview {
    WIPListView()
}
