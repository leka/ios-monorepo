// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

@main
struct LekaApp: App {

    @StateObject var viewRouter = ViewRouter()
    @StateObject var metrics = UIMetrics()
    @StateObject var sidebar = SidebarViewModel()
    @StateObject var company = CompanyViewModel()
    @StateObject var settings = SettingsViewModel()
    @StateObject var curriculumVM = CurriculumViewModel()
    @StateObject var activityVM = ActivityViewModel()
    @StateObject var botVM = BotViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    curriculumVM.populateCurriculumList(category: .emotionRecognition)
                    curriculumVM.getCompleteActivityList()
                }
                .environmentObject(viewRouter)
                .environmentObject(metrics)
                .environmentObject(sidebar)
                .environmentObject(company)
                .environmentObject(settings)
                .environmentObject(curriculumVM)
                .environmentObject(activityVM)
                .environmentObject(botVM)
        }
    }
}
