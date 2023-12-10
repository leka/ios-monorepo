// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct LekaApp: App {
    @StateObject var viewRouter = ViewRouter()
    @StateObject var metrics = UIMetrics()
    @StateObject var navigationVM = NavigationViewModel()
    @StateObject var company = CompanyViewModel()
    @StateObject var settings = SettingsViewModel()
    @StateObject var curriculumVM = CurriculumViewModel()
    @StateObject var activityVM = ActivityViewModel()
    @StateObject var robotVM = RobotViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    self.curriculumVM.populateCurriculumList(category: .emotionRecognition)
                    self.curriculumVM.getCompleteActivityList()
                }
                .environmentObject(self.viewRouter)
                .environmentObject(self.metrics)
                .environmentObject(self.navigationVM)
                .environmentObject(self.company)
                .environmentObject(self.settings)
                .environmentObject(self.curriculumVM)
                .environmentObject(self.activityVM)
                .environmentObject(self.robotVM)
        }
    }
}
