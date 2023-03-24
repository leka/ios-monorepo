//
//  ContentView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/11/22.
//

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject var sidebar: SidebarViewModel
	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var metrics: UIMetrics
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var curriculumVM: CurriculumViewModel
	@EnvironmentObject var activityVM: ActivityViewModel
	@EnvironmentObject var botVM: BotViewModel
	
	var body: some View {
		Group {
			switch viewRouter.currentPage {
				case .welcome:
					WelcomeView()
						.transition(.opacity)
				case .profiles:
					NavigationStack {
						ProfileEditorView()
					}
					.transition(.move(edge: .trailing))
				case .bots:
					NavigationStack {
						BotPicker()
					}
					.transition(.move(edge: .trailing))
				case .home:
					HomeView()
						.transition(.opacity)
				case .curriculumDetail:
					CurriculumDetailsView()
						.transition(.move(edge: .trailing))
				case .game:
					NavigationStack {
						if viewRouter.showUserSelector {
							ProfileSelector_Users()
						} else {
							GameView()
						}
					}
					.transition(.move(edge: .trailing))
			}
		}
		.animation(.default, value: viewRouter.currentPage)
		.preferredColorScheme(.light)
	}
}
