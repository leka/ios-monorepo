//
//  SelectedActivityInstructions.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 10/3/23.
//

import SwiftUI

// Modal content when picking an activity within the ActivityList
struct SelectedActivityInstructionsView: View {
	
	@EnvironmentObject var activityVM: ActivityViewModel
	@EnvironmentObject var company: CompanyViewModel
	@EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var metrics: UIMetrics
	@Environment(\.dismiss) var dismiss
	
	private func goButtonAction() {
		activityVM.setupGame(with: activityVM.currentActivity)
		dismiss()
		if settings.companyIsConnected && !company.selectionSetIsCorrect() {
			viewRouter.showUserSelector = true
		}
		viewRouter.goToGameFromActivities = true
	}
	
	var body: some View {
		ZStack(alignment: .top) {
			// NavigationBar color
			Color("lekaLightBlue").ignoresSafeArea()
			
			// Background Color (only visible under the header here)
			Color.accentColor
			
			VStack(spacing: 0) {
				activityDetailHeader
				Rectangle()
					.fill(Color("lekaLightGray"))
					.edgesIgnoringSafeArea(.bottom)
					.overlay { InstructionsView() }
					.overlay { GoButton { goButtonAction() } }
			}
		}
		.preferredColorScheme(.light)
	}
	
	private var activityDetailHeader: some View {
		HStack {
			Spacer()
			Text(activityVM.currentActivity.title.localized())
				.font(metrics.semi17)
				.foregroundColor(.white)
				.multilineTextAlignment(.center)
			Spacer()
		}
		.frame(width: 420, height: 90)
	}
}
