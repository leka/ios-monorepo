// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct LekaAppDeprecated: App {
    @StateObject var viewRouter = ViewRouterDeprecated()
    @StateObject var metrics = UIMetrics()
    @StateObject var navigationVM = NavigationViewModelDeprecated()
    @StateObject var company = CompanyViewModelDeprecated()
    @StateObject var settings = SettingsViewModelDeprecated()
    @StateObject var curriculumVM = CurriculumViewModelDeprecated()
    @StateObject var activityVM = ActivityViewModelDeprecated()
    @StateObject var robotVM = RobotViewModel()

    var body: some Scene {
        WindowGroup {
            ContentViewDeprecated()
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
